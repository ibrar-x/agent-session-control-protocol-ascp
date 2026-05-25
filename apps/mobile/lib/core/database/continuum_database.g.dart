// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'continuum_database.dart';

// ignore_for_file: type=lint
class $ReplayCursorsTable extends ReplayCursors
    with TableInfo<$ReplayCursorsTable, ReplayCursor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReplayCursorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _hostIdMeta = const VerificationMeta('hostId');
  @override
  late final GeneratedColumn<String> hostId = GeneratedColumn<String>(
    'host_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sequenceMeta = const VerificationMeta(
    'sequence',
  );
  @override
  late final GeneratedColumn<int> sequence = GeneratedColumn<int>(
    'sequence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    hostId,
    sessionId,
    sequence,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'replay_cursors';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReplayCursor> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('host_id')) {
      context.handle(
        _hostIdMeta,
        hostId.isAcceptableOrUnknown(data['host_id']!, _hostIdMeta),
      );
    } else if (isInserting) {
      context.missing(_hostIdMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('sequence')) {
      context.handle(
        _sequenceMeta,
        sequence.isAcceptableOrUnknown(data['sequence']!, _sequenceMeta),
      );
    } else if (isInserting) {
      context.missing(_sequenceMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {hostId, sessionId};
  @override
  ReplayCursor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReplayCursor(
      hostId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}host_id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      sequence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sequence'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ReplayCursorsTable createAlias(String alias) {
    return $ReplayCursorsTable(attachedDatabase, alias);
  }
}

class ReplayCursor extends DataClass implements Insertable<ReplayCursor> {
  final String hostId;
  final String sessionId;
  final int sequence;
  final DateTime updatedAt;
  const ReplayCursor({
    required this.hostId,
    required this.sessionId,
    required this.sequence,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['host_id'] = Variable<String>(hostId);
    map['session_id'] = Variable<String>(sessionId);
    map['sequence'] = Variable<int>(sequence);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ReplayCursorsCompanion toCompanion(bool nullToAbsent) {
    return ReplayCursorsCompanion(
      hostId: Value(hostId),
      sessionId: Value(sessionId),
      sequence: Value(sequence),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReplayCursor.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReplayCursor(
      hostId: serializer.fromJson<String>(json['hostId']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      sequence: serializer.fromJson<int>(json['sequence']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'hostId': serializer.toJson<String>(hostId),
      'sessionId': serializer.toJson<String>(sessionId),
      'sequence': serializer.toJson<int>(sequence),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ReplayCursor copyWith({
    String? hostId,
    String? sessionId,
    int? sequence,
    DateTime? updatedAt,
  }) => ReplayCursor(
    hostId: hostId ?? this.hostId,
    sessionId: sessionId ?? this.sessionId,
    sequence: sequence ?? this.sequence,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ReplayCursor copyWithCompanion(ReplayCursorsCompanion data) {
    return ReplayCursor(
      hostId: data.hostId.present ? data.hostId.value : this.hostId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      sequence: data.sequence.present ? data.sequence.value : this.sequence,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReplayCursor(')
          ..write('hostId: $hostId, ')
          ..write('sessionId: $sessionId, ')
          ..write('sequence: $sequence, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(hostId, sessionId, sequence, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReplayCursor &&
          other.hostId == this.hostId &&
          other.sessionId == this.sessionId &&
          other.sequence == this.sequence &&
          other.updatedAt == this.updatedAt);
}

class ReplayCursorsCompanion extends UpdateCompanion<ReplayCursor> {
  final Value<String> hostId;
  final Value<String> sessionId;
  final Value<int> sequence;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ReplayCursorsCompanion({
    this.hostId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.sequence = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReplayCursorsCompanion.insert({
    required String hostId,
    required String sessionId,
    required int sequence,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : hostId = Value(hostId),
       sessionId = Value(sessionId),
       sequence = Value(sequence);
  static Insertable<ReplayCursor> custom({
    Expression<String>? hostId,
    Expression<String>? sessionId,
    Expression<int>? sequence,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (hostId != null) 'host_id': hostId,
      if (sessionId != null) 'session_id': sessionId,
      if (sequence != null) 'sequence': sequence,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReplayCursorsCompanion copyWith({
    Value<String>? hostId,
    Value<String>? sessionId,
    Value<int>? sequence,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ReplayCursorsCompanion(
      hostId: hostId ?? this.hostId,
      sessionId: sessionId ?? this.sessionId,
      sequence: sequence ?? this.sequence,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (hostId.present) {
      map['host_id'] = Variable<String>(hostId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (sequence.present) {
      map['sequence'] = Variable<int>(sequence.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReplayCursorsCompanion(')
          ..write('hostId: $hostId, ')
          ..write('sessionId: $sessionId, ')
          ..write('sequence: $sequence, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedSessionsTable extends CachedSessions
    with TableInfo<$CachedSessionsTable, CachedSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _hostIdMeta = const VerificationMeta('hostId');
  @override
  late final GeneratedColumn<String> hostId = GeneratedColumn<String>(
    'host_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    hostId,
    sessionId,
    title,
    status,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('host_id')) {
      context.handle(
        _hostIdMeta,
        hostId.isAcceptableOrUnknown(data['host_id']!, _hostIdMeta),
      );
    } else if (isInserting) {
      context.missing(_hostIdMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {hostId, sessionId};
  @override
  CachedSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedSession(
      hostId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}host_id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CachedSessionsTable createAlias(String alias) {
    return $CachedSessionsTable(attachedDatabase, alias);
  }
}

class CachedSession extends DataClass implements Insertable<CachedSession> {
  final String hostId;
  final String sessionId;
  final String title;
  final String status;
  final DateTime updatedAt;
  const CachedSession({
    required this.hostId,
    required this.sessionId,
    required this.title,
    required this.status,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['host_id'] = Variable<String>(hostId);
    map['session_id'] = Variable<String>(sessionId);
    map['title'] = Variable<String>(title);
    map['status'] = Variable<String>(status);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CachedSessionsCompanion toCompanion(bool nullToAbsent) {
    return CachedSessionsCompanion(
      hostId: Value(hostId),
      sessionId: Value(sessionId),
      title: Value(title),
      status: Value(status),
      updatedAt: Value(updatedAt),
    );
  }

  factory CachedSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedSession(
      hostId: serializer.fromJson<String>(json['hostId']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      title: serializer.fromJson<String>(json['title']),
      status: serializer.fromJson<String>(json['status']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'hostId': serializer.toJson<String>(hostId),
      'sessionId': serializer.toJson<String>(sessionId),
      'title': serializer.toJson<String>(title),
      'status': serializer.toJson<String>(status),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CachedSession copyWith({
    String? hostId,
    String? sessionId,
    String? title,
    String? status,
    DateTime? updatedAt,
  }) => CachedSession(
    hostId: hostId ?? this.hostId,
    sessionId: sessionId ?? this.sessionId,
    title: title ?? this.title,
    status: status ?? this.status,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CachedSession copyWithCompanion(CachedSessionsCompanion data) {
    return CachedSession(
      hostId: data.hostId.present ? data.hostId.value : this.hostId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      title: data.title.present ? data.title.value : this.title,
      status: data.status.present ? data.status.value : this.status,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedSession(')
          ..write('hostId: $hostId, ')
          ..write('sessionId: $sessionId, ')
          ..write('title: $title, ')
          ..write('status: $status, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(hostId, sessionId, title, status, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedSession &&
          other.hostId == this.hostId &&
          other.sessionId == this.sessionId &&
          other.title == this.title &&
          other.status == this.status &&
          other.updatedAt == this.updatedAt);
}

class CachedSessionsCompanion extends UpdateCompanion<CachedSession> {
  final Value<String> hostId;
  final Value<String> sessionId;
  final Value<String> title;
  final Value<String> status;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CachedSessionsCompanion({
    this.hostId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.title = const Value.absent(),
    this.status = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedSessionsCompanion.insert({
    required String hostId,
    required String sessionId,
    required String title,
    required String status,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : hostId = Value(hostId),
       sessionId = Value(sessionId),
       title = Value(title),
       status = Value(status),
       updatedAt = Value(updatedAt);
  static Insertable<CachedSession> custom({
    Expression<String>? hostId,
    Expression<String>? sessionId,
    Expression<String>? title,
    Expression<String>? status,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (hostId != null) 'host_id': hostId,
      if (sessionId != null) 'session_id': sessionId,
      if (title != null) 'title': title,
      if (status != null) 'status': status,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedSessionsCompanion copyWith({
    Value<String>? hostId,
    Value<String>? sessionId,
    Value<String>? title,
    Value<String>? status,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CachedSessionsCompanion(
      hostId: hostId ?? this.hostId,
      sessionId: sessionId ?? this.sessionId,
      title: title ?? this.title,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (hostId.present) {
      map['host_id'] = Variable<String>(hostId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedSessionsCompanion(')
          ..write('hostId: $hostId, ')
          ..write('sessionId: $sessionId, ')
          ..write('title: $title, ')
          ..write('status: $status, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedArtifactsTable extends CachedArtifacts
    with TableInfo<$CachedArtifactsTable, CachedArtifact> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedArtifactsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _hostIdMeta = const VerificationMeta('hostId');
  @override
  late final GeneratedColumn<String> hostId = GeneratedColumn<String>(
    'host_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _artifactIdMeta = const VerificationMeta(
    'artifactId',
  );
  @override
  late final GeneratedColumn<String> artifactId = GeneratedColumn<String>(
    'artifact_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    hostId,
    sessionId,
    artifactId,
    name,
    mimeType,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_artifacts';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedArtifact> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('host_id')) {
      context.handle(
        _hostIdMeta,
        hostId.isAcceptableOrUnknown(data['host_id']!, _hostIdMeta),
      );
    } else if (isInserting) {
      context.missing(_hostIdMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('artifact_id')) {
      context.handle(
        _artifactIdMeta,
        artifactId.isAcceptableOrUnknown(data['artifact_id']!, _artifactIdMeta),
      );
    } else if (isInserting) {
      context.missing(_artifactIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mimeTypeMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {hostId, sessionId, artifactId};
  @override
  CachedArtifact map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedArtifact(
      hostId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}host_id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      artifactId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}artifact_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CachedArtifactsTable createAlias(String alias) {
    return $CachedArtifactsTable(attachedDatabase, alias);
  }
}

class CachedArtifact extends DataClass implements Insertable<CachedArtifact> {
  final String hostId;
  final String sessionId;
  final String artifactId;
  final String name;
  final String mimeType;
  final DateTime updatedAt;
  const CachedArtifact({
    required this.hostId,
    required this.sessionId,
    required this.artifactId,
    required this.name,
    required this.mimeType,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['host_id'] = Variable<String>(hostId);
    map['session_id'] = Variable<String>(sessionId);
    map['artifact_id'] = Variable<String>(artifactId);
    map['name'] = Variable<String>(name);
    map['mime_type'] = Variable<String>(mimeType);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CachedArtifactsCompanion toCompanion(bool nullToAbsent) {
    return CachedArtifactsCompanion(
      hostId: Value(hostId),
      sessionId: Value(sessionId),
      artifactId: Value(artifactId),
      name: Value(name),
      mimeType: Value(mimeType),
      updatedAt: Value(updatedAt),
    );
  }

  factory CachedArtifact.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedArtifact(
      hostId: serializer.fromJson<String>(json['hostId']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      artifactId: serializer.fromJson<String>(json['artifactId']),
      name: serializer.fromJson<String>(json['name']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'hostId': serializer.toJson<String>(hostId),
      'sessionId': serializer.toJson<String>(sessionId),
      'artifactId': serializer.toJson<String>(artifactId),
      'name': serializer.toJson<String>(name),
      'mimeType': serializer.toJson<String>(mimeType),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CachedArtifact copyWith({
    String? hostId,
    String? sessionId,
    String? artifactId,
    String? name,
    String? mimeType,
    DateTime? updatedAt,
  }) => CachedArtifact(
    hostId: hostId ?? this.hostId,
    sessionId: sessionId ?? this.sessionId,
    artifactId: artifactId ?? this.artifactId,
    name: name ?? this.name,
    mimeType: mimeType ?? this.mimeType,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CachedArtifact copyWithCompanion(CachedArtifactsCompanion data) {
    return CachedArtifact(
      hostId: data.hostId.present ? data.hostId.value : this.hostId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      artifactId: data.artifactId.present
          ? data.artifactId.value
          : this.artifactId,
      name: data.name.present ? data.name.value : this.name,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedArtifact(')
          ..write('hostId: $hostId, ')
          ..write('sessionId: $sessionId, ')
          ..write('artifactId: $artifactId, ')
          ..write('name: $name, ')
          ..write('mimeType: $mimeType, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(hostId, sessionId, artifactId, name, mimeType, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedArtifact &&
          other.hostId == this.hostId &&
          other.sessionId == this.sessionId &&
          other.artifactId == this.artifactId &&
          other.name == this.name &&
          other.mimeType == this.mimeType &&
          other.updatedAt == this.updatedAt);
}

class CachedArtifactsCompanion extends UpdateCompanion<CachedArtifact> {
  final Value<String> hostId;
  final Value<String> sessionId;
  final Value<String> artifactId;
  final Value<String> name;
  final Value<String> mimeType;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CachedArtifactsCompanion({
    this.hostId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.artifactId = const Value.absent(),
    this.name = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedArtifactsCompanion.insert({
    required String hostId,
    required String sessionId,
    required String artifactId,
    required String name,
    required String mimeType,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : hostId = Value(hostId),
       sessionId = Value(sessionId),
       artifactId = Value(artifactId),
       name = Value(name),
       mimeType = Value(mimeType);
  static Insertable<CachedArtifact> custom({
    Expression<String>? hostId,
    Expression<String>? sessionId,
    Expression<String>? artifactId,
    Expression<String>? name,
    Expression<String>? mimeType,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (hostId != null) 'host_id': hostId,
      if (sessionId != null) 'session_id': sessionId,
      if (artifactId != null) 'artifact_id': artifactId,
      if (name != null) 'name': name,
      if (mimeType != null) 'mime_type': mimeType,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedArtifactsCompanion copyWith({
    Value<String>? hostId,
    Value<String>? sessionId,
    Value<String>? artifactId,
    Value<String>? name,
    Value<String>? mimeType,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CachedArtifactsCompanion(
      hostId: hostId ?? this.hostId,
      sessionId: sessionId ?? this.sessionId,
      artifactId: artifactId ?? this.artifactId,
      name: name ?? this.name,
      mimeType: mimeType ?? this.mimeType,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (hostId.present) {
      map['host_id'] = Variable<String>(hostId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (artifactId.present) {
      map['artifact_id'] = Variable<String>(artifactId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedArtifactsCompanion(')
          ..write('hostId: $hostId, ')
          ..write('sessionId: $sessionId, ')
          ..write('artifactId: $artifactId, ')
          ..write('name: $name, ')
          ..write('mimeType: $mimeType, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedDiffsTable extends CachedDiffs
    with TableInfo<$CachedDiffsTable, CachedDiff> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedDiffsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _hostIdMeta = const VerificationMeta('hostId');
  @override
  late final GeneratedColumn<String> hostId = GeneratedColumn<String>(
    'host_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diffIdMeta = const VerificationMeta('diffId');
  @override
  late final GeneratedColumn<String> diffId = GeneratedColumn<String>(
    'diff_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileCountMeta = const VerificationMeta(
    'fileCount',
  );
  @override
  late final GeneratedColumn<int> fileCount = GeneratedColumn<int>(
    'file_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    hostId,
    sessionId,
    diffId,
    summary,
    fileCount,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_diffs';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedDiff> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('host_id')) {
      context.handle(
        _hostIdMeta,
        hostId.isAcceptableOrUnknown(data['host_id']!, _hostIdMeta),
      );
    } else if (isInserting) {
      context.missing(_hostIdMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('diff_id')) {
      context.handle(
        _diffIdMeta,
        diffId.isAcceptableOrUnknown(data['diff_id']!, _diffIdMeta),
      );
    } else if (isInserting) {
      context.missing(_diffIdMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    if (data.containsKey('file_count')) {
      context.handle(
        _fileCountMeta,
        fileCount.isAcceptableOrUnknown(data['file_count']!, _fileCountMeta),
      );
    } else if (isInserting) {
      context.missing(_fileCountMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {hostId, sessionId, diffId};
  @override
  CachedDiff map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedDiff(
      hostId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}host_id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      diffId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diff_id'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
      fileCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_count'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CachedDiffsTable createAlias(String alias) {
    return $CachedDiffsTable(attachedDatabase, alias);
  }
}

class CachedDiff extends DataClass implements Insertable<CachedDiff> {
  final String hostId;
  final String sessionId;
  final String diffId;
  final String summary;
  final int fileCount;
  final DateTime updatedAt;
  const CachedDiff({
    required this.hostId,
    required this.sessionId,
    required this.diffId,
    required this.summary,
    required this.fileCount,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['host_id'] = Variable<String>(hostId);
    map['session_id'] = Variable<String>(sessionId);
    map['diff_id'] = Variable<String>(diffId);
    map['summary'] = Variable<String>(summary);
    map['file_count'] = Variable<int>(fileCount);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CachedDiffsCompanion toCompanion(bool nullToAbsent) {
    return CachedDiffsCompanion(
      hostId: Value(hostId),
      sessionId: Value(sessionId),
      diffId: Value(diffId),
      summary: Value(summary),
      fileCount: Value(fileCount),
      updatedAt: Value(updatedAt),
    );
  }

  factory CachedDiff.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedDiff(
      hostId: serializer.fromJson<String>(json['hostId']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      diffId: serializer.fromJson<String>(json['diffId']),
      summary: serializer.fromJson<String>(json['summary']),
      fileCount: serializer.fromJson<int>(json['fileCount']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'hostId': serializer.toJson<String>(hostId),
      'sessionId': serializer.toJson<String>(sessionId),
      'diffId': serializer.toJson<String>(diffId),
      'summary': serializer.toJson<String>(summary),
      'fileCount': serializer.toJson<int>(fileCount),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CachedDiff copyWith({
    String? hostId,
    String? sessionId,
    String? diffId,
    String? summary,
    int? fileCount,
    DateTime? updatedAt,
  }) => CachedDiff(
    hostId: hostId ?? this.hostId,
    sessionId: sessionId ?? this.sessionId,
    diffId: diffId ?? this.diffId,
    summary: summary ?? this.summary,
    fileCount: fileCount ?? this.fileCount,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CachedDiff copyWithCompanion(CachedDiffsCompanion data) {
    return CachedDiff(
      hostId: data.hostId.present ? data.hostId.value : this.hostId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      diffId: data.diffId.present ? data.diffId.value : this.diffId,
      summary: data.summary.present ? data.summary.value : this.summary,
      fileCount: data.fileCount.present ? data.fileCount.value : this.fileCount,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedDiff(')
          ..write('hostId: $hostId, ')
          ..write('sessionId: $sessionId, ')
          ..write('diffId: $diffId, ')
          ..write('summary: $summary, ')
          ..write('fileCount: $fileCount, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(hostId, sessionId, diffId, summary, fileCount, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedDiff &&
          other.hostId == this.hostId &&
          other.sessionId == this.sessionId &&
          other.diffId == this.diffId &&
          other.summary == this.summary &&
          other.fileCount == this.fileCount &&
          other.updatedAt == this.updatedAt);
}

class CachedDiffsCompanion extends UpdateCompanion<CachedDiff> {
  final Value<String> hostId;
  final Value<String> sessionId;
  final Value<String> diffId;
  final Value<String> summary;
  final Value<int> fileCount;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CachedDiffsCompanion({
    this.hostId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.diffId = const Value.absent(),
    this.summary = const Value.absent(),
    this.fileCount = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedDiffsCompanion.insert({
    required String hostId,
    required String sessionId,
    required String diffId,
    required String summary,
    required int fileCount,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : hostId = Value(hostId),
       sessionId = Value(sessionId),
       diffId = Value(diffId),
       summary = Value(summary),
       fileCount = Value(fileCount);
  static Insertable<CachedDiff> custom({
    Expression<String>? hostId,
    Expression<String>? sessionId,
    Expression<String>? diffId,
    Expression<String>? summary,
    Expression<int>? fileCount,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (hostId != null) 'host_id': hostId,
      if (sessionId != null) 'session_id': sessionId,
      if (diffId != null) 'diff_id': diffId,
      if (summary != null) 'summary': summary,
      if (fileCount != null) 'file_count': fileCount,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedDiffsCompanion copyWith({
    Value<String>? hostId,
    Value<String>? sessionId,
    Value<String>? diffId,
    Value<String>? summary,
    Value<int>? fileCount,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CachedDiffsCompanion(
      hostId: hostId ?? this.hostId,
      sessionId: sessionId ?? this.sessionId,
      diffId: diffId ?? this.diffId,
      summary: summary ?? this.summary,
      fileCount: fileCount ?? this.fileCount,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (hostId.present) {
      map['host_id'] = Variable<String>(hostId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (diffId.present) {
      map['diff_id'] = Variable<String>(diffId.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (fileCount.present) {
      map['file_count'] = Variable<int>(fileCount.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedDiffsCompanion(')
          ..write('hostId: $hostId, ')
          ..write('sessionId: $sessionId, ')
          ..write('diffId: $diffId, ')
          ..write('summary: $summary, ')
          ..write('fileCount: $fileCount, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$ContinuumDatabase extends GeneratedDatabase {
  _$ContinuumDatabase(QueryExecutor e) : super(e);
  $ContinuumDatabaseManager get managers => $ContinuumDatabaseManager(this);
  late final $ReplayCursorsTable replayCursors = $ReplayCursorsTable(this);
  late final $CachedSessionsTable cachedSessions = $CachedSessionsTable(this);
  late final $CachedArtifactsTable cachedArtifacts = $CachedArtifactsTable(
    this,
  );
  late final $CachedDiffsTable cachedDiffs = $CachedDiffsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    replayCursors,
    cachedSessions,
    cachedArtifacts,
    cachedDiffs,
  ];
}

typedef $$ReplayCursorsTableCreateCompanionBuilder =
    ReplayCursorsCompanion Function({
      required String hostId,
      required String sessionId,
      required int sequence,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$ReplayCursorsTableUpdateCompanionBuilder =
    ReplayCursorsCompanion Function({
      Value<String> hostId,
      Value<String> sessionId,
      Value<int> sequence,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ReplayCursorsTableFilterComposer
    extends Composer<_$ContinuumDatabase, $ReplayCursorsTable> {
  $$ReplayCursorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get hostId => $composableBuilder(
    column: $table.hostId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sequence => $composableBuilder(
    column: $table.sequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReplayCursorsTableOrderingComposer
    extends Composer<_$ContinuumDatabase, $ReplayCursorsTable> {
  $$ReplayCursorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get hostId => $composableBuilder(
    column: $table.hostId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sequence => $composableBuilder(
    column: $table.sequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReplayCursorsTableAnnotationComposer
    extends Composer<_$ContinuumDatabase, $ReplayCursorsTable> {
  $$ReplayCursorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get hostId =>
      $composableBuilder(column: $table.hostId, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<int> get sequence =>
      $composableBuilder(column: $table.sequence, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ReplayCursorsTableTableManager
    extends
        RootTableManager<
          _$ContinuumDatabase,
          $ReplayCursorsTable,
          ReplayCursor,
          $$ReplayCursorsTableFilterComposer,
          $$ReplayCursorsTableOrderingComposer,
          $$ReplayCursorsTableAnnotationComposer,
          $$ReplayCursorsTableCreateCompanionBuilder,
          $$ReplayCursorsTableUpdateCompanionBuilder,
          (
            ReplayCursor,
            BaseReferences<
              _$ContinuumDatabase,
              $ReplayCursorsTable,
              ReplayCursor
            >,
          ),
          ReplayCursor,
          PrefetchHooks Function()
        > {
  $$ReplayCursorsTableTableManager(
    _$ContinuumDatabase db,
    $ReplayCursorsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReplayCursorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReplayCursorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReplayCursorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> hostId = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<int> sequence = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReplayCursorsCompanion(
                hostId: hostId,
                sessionId: sessionId,
                sequence: sequence,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String hostId,
                required String sessionId,
                required int sequence,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReplayCursorsCompanion.insert(
                hostId: hostId,
                sessionId: sessionId,
                sequence: sequence,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReplayCursorsTableProcessedTableManager =
    ProcessedTableManager<
      _$ContinuumDatabase,
      $ReplayCursorsTable,
      ReplayCursor,
      $$ReplayCursorsTableFilterComposer,
      $$ReplayCursorsTableOrderingComposer,
      $$ReplayCursorsTableAnnotationComposer,
      $$ReplayCursorsTableCreateCompanionBuilder,
      $$ReplayCursorsTableUpdateCompanionBuilder,
      (
        ReplayCursor,
        BaseReferences<_$ContinuumDatabase, $ReplayCursorsTable, ReplayCursor>,
      ),
      ReplayCursor,
      PrefetchHooks Function()
    >;
typedef $$CachedSessionsTableCreateCompanionBuilder =
    CachedSessionsCompanion Function({
      required String hostId,
      required String sessionId,
      required String title,
      required String status,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CachedSessionsTableUpdateCompanionBuilder =
    CachedSessionsCompanion Function({
      Value<String> hostId,
      Value<String> sessionId,
      Value<String> title,
      Value<String> status,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CachedSessionsTableFilterComposer
    extends Composer<_$ContinuumDatabase, $CachedSessionsTable> {
  $$CachedSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get hostId => $composableBuilder(
    column: $table.hostId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedSessionsTableOrderingComposer
    extends Composer<_$ContinuumDatabase, $CachedSessionsTable> {
  $$CachedSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get hostId => $composableBuilder(
    column: $table.hostId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedSessionsTableAnnotationComposer
    extends Composer<_$ContinuumDatabase, $CachedSessionsTable> {
  $$CachedSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get hostId =>
      $composableBuilder(column: $table.hostId, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CachedSessionsTableTableManager
    extends
        RootTableManager<
          _$ContinuumDatabase,
          $CachedSessionsTable,
          CachedSession,
          $$CachedSessionsTableFilterComposer,
          $$CachedSessionsTableOrderingComposer,
          $$CachedSessionsTableAnnotationComposer,
          $$CachedSessionsTableCreateCompanionBuilder,
          $$CachedSessionsTableUpdateCompanionBuilder,
          (
            CachedSession,
            BaseReferences<
              _$ContinuumDatabase,
              $CachedSessionsTable,
              CachedSession
            >,
          ),
          CachedSession,
          PrefetchHooks Function()
        > {
  $$CachedSessionsTableTableManager(
    _$ContinuumDatabase db,
    $CachedSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> hostId = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedSessionsCompanion(
                hostId: hostId,
                sessionId: sessionId,
                title: title,
                status: status,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String hostId,
                required String sessionId,
                required String title,
                required String status,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedSessionsCompanion.insert(
                hostId: hostId,
                sessionId: sessionId,
                title: title,
                status: status,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$ContinuumDatabase,
      $CachedSessionsTable,
      CachedSession,
      $$CachedSessionsTableFilterComposer,
      $$CachedSessionsTableOrderingComposer,
      $$CachedSessionsTableAnnotationComposer,
      $$CachedSessionsTableCreateCompanionBuilder,
      $$CachedSessionsTableUpdateCompanionBuilder,
      (
        CachedSession,
        BaseReferences<
          _$ContinuumDatabase,
          $CachedSessionsTable,
          CachedSession
        >,
      ),
      CachedSession,
      PrefetchHooks Function()
    >;
typedef $$CachedArtifactsTableCreateCompanionBuilder =
    CachedArtifactsCompanion Function({
      required String hostId,
      required String sessionId,
      required String artifactId,
      required String name,
      required String mimeType,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$CachedArtifactsTableUpdateCompanionBuilder =
    CachedArtifactsCompanion Function({
      Value<String> hostId,
      Value<String> sessionId,
      Value<String> artifactId,
      Value<String> name,
      Value<String> mimeType,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CachedArtifactsTableFilterComposer
    extends Composer<_$ContinuumDatabase, $CachedArtifactsTable> {
  $$CachedArtifactsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get hostId => $composableBuilder(
    column: $table.hostId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get artifactId => $composableBuilder(
    column: $table.artifactId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedArtifactsTableOrderingComposer
    extends Composer<_$ContinuumDatabase, $CachedArtifactsTable> {
  $$CachedArtifactsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get hostId => $composableBuilder(
    column: $table.hostId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artifactId => $composableBuilder(
    column: $table.artifactId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedArtifactsTableAnnotationComposer
    extends Composer<_$ContinuumDatabase, $CachedArtifactsTable> {
  $$CachedArtifactsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get hostId =>
      $composableBuilder(column: $table.hostId, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get artifactId => $composableBuilder(
    column: $table.artifactId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CachedArtifactsTableTableManager
    extends
        RootTableManager<
          _$ContinuumDatabase,
          $CachedArtifactsTable,
          CachedArtifact,
          $$CachedArtifactsTableFilterComposer,
          $$CachedArtifactsTableOrderingComposer,
          $$CachedArtifactsTableAnnotationComposer,
          $$CachedArtifactsTableCreateCompanionBuilder,
          $$CachedArtifactsTableUpdateCompanionBuilder,
          (
            CachedArtifact,
            BaseReferences<
              _$ContinuumDatabase,
              $CachedArtifactsTable,
              CachedArtifact
            >,
          ),
          CachedArtifact,
          PrefetchHooks Function()
        > {
  $$CachedArtifactsTableTableManager(
    _$ContinuumDatabase db,
    $CachedArtifactsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedArtifactsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedArtifactsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedArtifactsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> hostId = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> artifactId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> mimeType = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedArtifactsCompanion(
                hostId: hostId,
                sessionId: sessionId,
                artifactId: artifactId,
                name: name,
                mimeType: mimeType,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String hostId,
                required String sessionId,
                required String artifactId,
                required String name,
                required String mimeType,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedArtifactsCompanion.insert(
                hostId: hostId,
                sessionId: sessionId,
                artifactId: artifactId,
                name: name,
                mimeType: mimeType,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedArtifactsTableProcessedTableManager =
    ProcessedTableManager<
      _$ContinuumDatabase,
      $CachedArtifactsTable,
      CachedArtifact,
      $$CachedArtifactsTableFilterComposer,
      $$CachedArtifactsTableOrderingComposer,
      $$CachedArtifactsTableAnnotationComposer,
      $$CachedArtifactsTableCreateCompanionBuilder,
      $$CachedArtifactsTableUpdateCompanionBuilder,
      (
        CachedArtifact,
        BaseReferences<
          _$ContinuumDatabase,
          $CachedArtifactsTable,
          CachedArtifact
        >,
      ),
      CachedArtifact,
      PrefetchHooks Function()
    >;
typedef $$CachedDiffsTableCreateCompanionBuilder =
    CachedDiffsCompanion Function({
      required String hostId,
      required String sessionId,
      required String diffId,
      required String summary,
      required int fileCount,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$CachedDiffsTableUpdateCompanionBuilder =
    CachedDiffsCompanion Function({
      Value<String> hostId,
      Value<String> sessionId,
      Value<String> diffId,
      Value<String> summary,
      Value<int> fileCount,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CachedDiffsTableFilterComposer
    extends Composer<_$ContinuumDatabase, $CachedDiffsTable> {
  $$CachedDiffsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get hostId => $composableBuilder(
    column: $table.hostId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get diffId => $composableBuilder(
    column: $table.diffId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileCount => $composableBuilder(
    column: $table.fileCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedDiffsTableOrderingComposer
    extends Composer<_$ContinuumDatabase, $CachedDiffsTable> {
  $$CachedDiffsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get hostId => $composableBuilder(
    column: $table.hostId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get diffId => $composableBuilder(
    column: $table.diffId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileCount => $composableBuilder(
    column: $table.fileCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedDiffsTableAnnotationComposer
    extends Composer<_$ContinuumDatabase, $CachedDiffsTable> {
  $$CachedDiffsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get hostId =>
      $composableBuilder(column: $table.hostId, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get diffId =>
      $composableBuilder(column: $table.diffId, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<int> get fileCount =>
      $composableBuilder(column: $table.fileCount, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CachedDiffsTableTableManager
    extends
        RootTableManager<
          _$ContinuumDatabase,
          $CachedDiffsTable,
          CachedDiff,
          $$CachedDiffsTableFilterComposer,
          $$CachedDiffsTableOrderingComposer,
          $$CachedDiffsTableAnnotationComposer,
          $$CachedDiffsTableCreateCompanionBuilder,
          $$CachedDiffsTableUpdateCompanionBuilder,
          (
            CachedDiff,
            BaseReferences<_$ContinuumDatabase, $CachedDiffsTable, CachedDiff>,
          ),
          CachedDiff,
          PrefetchHooks Function()
        > {
  $$CachedDiffsTableTableManager(
    _$ContinuumDatabase db,
    $CachedDiffsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedDiffsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedDiffsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedDiffsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> hostId = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> diffId = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<int> fileCount = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedDiffsCompanion(
                hostId: hostId,
                sessionId: sessionId,
                diffId: diffId,
                summary: summary,
                fileCount: fileCount,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String hostId,
                required String sessionId,
                required String diffId,
                required String summary,
                required int fileCount,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedDiffsCompanion.insert(
                hostId: hostId,
                sessionId: sessionId,
                diffId: diffId,
                summary: summary,
                fileCount: fileCount,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedDiffsTableProcessedTableManager =
    ProcessedTableManager<
      _$ContinuumDatabase,
      $CachedDiffsTable,
      CachedDiff,
      $$CachedDiffsTableFilterComposer,
      $$CachedDiffsTableOrderingComposer,
      $$CachedDiffsTableAnnotationComposer,
      $$CachedDiffsTableCreateCompanionBuilder,
      $$CachedDiffsTableUpdateCompanionBuilder,
      (
        CachedDiff,
        BaseReferences<_$ContinuumDatabase, $CachedDiffsTable, CachedDiff>,
      ),
      CachedDiff,
      PrefetchHooks Function()
    >;

class $ContinuumDatabaseManager {
  final _$ContinuumDatabase _db;
  $ContinuumDatabaseManager(this._db);
  $$ReplayCursorsTableTableManager get replayCursors =>
      $$ReplayCursorsTableTableManager(_db, _db.replayCursors);
  $$CachedSessionsTableTableManager get cachedSessions =>
      $$CachedSessionsTableTableManager(_db, _db.cachedSessions);
  $$CachedArtifactsTableTableManager get cachedArtifacts =>
      $$CachedArtifactsTableTableManager(_db, _db.cachedArtifacts);
  $$CachedDiffsTableTableManager get cachedDiffs =>
      $$CachedDiffsTableTableManager(_db, _db.cachedDiffs);
}
