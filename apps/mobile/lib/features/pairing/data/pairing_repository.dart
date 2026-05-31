import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../core/security/trust_material.dart';
import '../domain/pairing_state.dart';

class PairingPayload {
  const PairingPayload({required this.hostUrl, required this.code});

  final Uri hostUrl;
  final String code;
}

class PairingClaimTicket {
  const PairingClaimTicket({
    required this.claim,
    required this.claimToken,
    required this.sessionId,
  });

  final PairingClaim claim;
  final String claimToken;
  final String sessionId;
}

class PairingPollOutcome {
  const PairingPollOutcome({
    required this.pollState,
    this.trustMaterial,
    this.failure,
  });

  final PairingPollState pollState;
  final TrustMaterial? trustMaterial;
  final PairingFailure? failure;
}

PairingPayload parsePairingPayload(String raw) {
  final uri = Uri.tryParse(raw);
  if (uri == null || !uri.hasScheme || uri.queryParameters.isEmpty) {
    throw const FormatException('Pairing payload is not a URI.');
  }
  final host = uri.queryParameters['host'];
  final code = uri.queryParameters['code'];
  if (host == null || code == null || code.isEmpty) {
    throw const FormatException('Pairing payload requires host and code.');
  }
  final hostUri = Uri.tryParse(host);
  if (hostUri == null || !hostUri.hasScheme) {
    throw const FormatException('Pairing host must be an absolute URI.');
  }
  return PairingPayload(hostUrl: hostUri, code: code);
}

PairingPayload parseManualPairingPayload(String raw, {String? defaultHostUrl}) {
  raw = raw.trim();
  if (raw.isEmpty) {
    throw const FormatException('Manual pairing payload cannot be empty.');
  }

  if (RegExp(r'^\d{4,8}$').hasMatch(raw)) {
    final hostUri = Uri.tryParse(defaultHostUrl ?? '');
    if (hostUri == null || !hostUri.hasScheme) {
      throw const FormatException(
        'Manual pairing code requires a default host URL.',
      );
    }
    return PairingPayload(hostUrl: hostUri, code: raw);
  }

  // Try JSON first
  if (raw.startsWith('{')) {
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final host = json['host'] as String?;
      final code = json['code'] as String?;
      if (host != null && code != null && host.isNotEmpty && code.isNotEmpty) {
        final hostUri = Uri.tryParse(host);
        if (hostUri != null && hostUri.hasScheme) {
          return PairingPayload(hostUrl: hostUri, code: code);
        }
      }
    } on FormatException {
      // Fall through to next parser
    }
  }

  // Try host:port:code format
  final colonParts = raw.split(':');
  if (colonParts.length >= 3) {
    final host = colonParts[0];
    final port = colonParts[1];
    final code = colonParts.sublist(2).join(':');
    if (host.isNotEmpty &&
        port.isNotEmpty &&
        code.isNotEmpty &&
        int.tryParse(port) != null) {
      final hostUri = Uri.tryParse('http://$host:$port');
      if (hostUri != null && hostUri.hasScheme) {
        return PairingPayload(hostUrl: hostUri, code: code);
      }
    }
  }

  // Try plain URI with query params
  final uri = Uri.tryParse(raw);
  if (uri != null && uri.hasScheme) {
    final code = uri.queryParameters['code'];
    if (code != null && code.isNotEmpty) {
      // Strip query params to get base host URL
      final hostUri = Uri(
        scheme: uri.scheme,
        userInfo: uri.userInfo,
        host: uri.host,
        port: uri.hasPort ? uri.port : null,
        path: uri.path,
      );
      return PairingPayload(hostUrl: hostUri, code: code);
    }
  }

  throw FormatException(
    'Manual pairing payload must be a numeric pairing code, JSON object, host:port:code, or a URI with a code query param. Input: $raw',
  );
}

abstract interface class PairingPollSimulator {
  PairingPollState simulatePoll(PairingClaim claim);
}

abstract interface class PairingClaimRepository {
  Future<PairingClaimTicket> claim(
    PairingPayload payload, {
    required String deviceLabel,
    DateTime? claimedAt,
  });

  Future<PairingPollOutcome> poll(PairingClaimTicket ticket);
}

class DeterministicPairingPollSimulator implements PairingPollSimulator {
  const DeterministicPairingPollSimulator();

  @override
  PairingPollState simulatePoll(PairingClaim claim) {
    final upper = claim.code.toUpperCase();
    if (upper == 'APPROVE' || upper == 'WIN' || upper == '111111') {
      return PairingPollState.approved;
    }
    if (upper.startsWith('REJECT') || upper == 'FAIL' || upper == '222222') {
      return PairingPollState.rejected;
    }
    if (upper.startsWith('EXPIRE') || upper == 'OLD' || upper == '333333') {
      return PairingPollState.expired;
    }
    if (upper.startsWith('REVOKE') || upper == 'RVK' || upper == '444444') {
      return PairingPollState.revoked;
    }
    if (upper.startsWith('UNREACH') || upper == 'NET' || upper == '555555') {
      return PairingPollState.unreachable;
    }
    return PairingPollState.pending;
  }
}

TrustMaterial deriveTrustMaterialFromApprovedClaim(PairingClaim claim) {
  // Derive deterministic trust material from approved claim.
  // In a real implementation this would come from the host response.
  final hostId = '${claim.hostUrl.host}:${claim.hostUrl.port}';
  final deviceId = 'mobile_${claim.code}';
  final secret =
      'secret_${claim.code}_${claim.claimedAt.millisecondsSinceEpoch}';
  return TrustMaterial(hostId: hostId, deviceId: deviceId, secret: secret);
}

class DaemonPairingRepository implements PairingClaimRepository {
  const DaemonPairingRepository({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<PairingClaimTicket> claim(
    PairingPayload payload, {
    required String deviceLabel,
    DateTime? claimedAt,
  }) async {
    final response = await _dio.postUri<Object?>(
      payload.hostUrl.resolve('/pairing/claim'),
      data: {'code': payload.code, 'device_label': deviceLabel},
      options: Options(contentType: Headers.jsonContentType),
    );
    final body = _asMap(response.data, 'pairing claim');
    final claimToken = body['claim_token'];
    final sessionId = body['session_id'];
    if (claimToken is! String || sessionId is! String) {
      throw const FormatException('Pairing claim response is incomplete.');
    }

    return PairingClaimTicket(
      claim: PairingClaim(
        hostUrl: payload.hostUrl,
        code: payload.code,
        claimedAt: claimedAt ?? DateTime.now(),
      ),
      claimToken: claimToken,
      sessionId: sessionId,
    );
  }

  @override
  Future<PairingPollOutcome> poll(PairingClaimTicket ticket) async {
    final response = await _dio.getUri<Object?>(
      ticket.claim.hostUrl.resolve(
        '/pairing/claims/${Uri.encodeComponent(ticket.claimToken)}',
      ),
    );
    final body = _asMap(response.data, 'pairing poll');
    final status = body['status'];
    if (status is! String) {
      throw const FormatException('Pairing poll response requires status.');
    }

    switch (status) {
      case 'pending_host_claim':
      case 'pending_host_approval':
        return const PairingPollOutcome(pollState: PairingPollState.pending);
      case 'approved':
      case 'consumed':
        final credentials = _asMap(body['credentials'], 'pairing credentials');
        final deviceId = credentials['device_id'];
        final secret = credentials['device_secret'];
        if (deviceId is! String || secret is! String) {
          throw const FormatException(
            'Approved pairing response requires credentials.',
          );
        }
        return PairingPollOutcome(
          pollState: PairingPollState.approved,
          trustMaterial: TrustMaterial(
            hostId: _hostId(ticket.claim.hostUrl),
            deviceId: deviceId,
            secret: secret,
          ),
        );
      case 'rejected':
        return const PairingPollOutcome(
          pollState: PairingPollState.rejected,
          failure: PairingFailure.rejectedByHost,
        );
      case 'expired':
        return const PairingPollOutcome(
          pollState: PairingPollState.expired,
          failure: PairingFailure.expired,
        );
      default:
        throw FormatException('Unsupported pairing poll status: $status');
    }
  }
}

Map<String, Object?> _asMap(Object? value, String context) {
  if (value is! Map) {
    throw FormatException('Expected $context response object.');
  }
  return Map<String, Object?>.from(value);
}

String _hostId(Uri uri) {
  final port = uri.hasPort ? ':${uri.port}' : '';
  return '${uri.host}$port';
}
