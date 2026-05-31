WORKING DIRECTORY: /Users/ibrar/Desktop/infinora.noworkspace/Continuum App/agent-session-control-protocol-ascp/apps/mobile

PROJECT: Flutter ASCP mobile companion.

TASK [T2-blackbox-qwen3.7-max]: QA audit only. Do not edit files.

Audit whether the app is live-ready and whether hardcoded/demo values leak into live mode. Inspect:
- lib/app/mobile_dependencies.dart
- lib/app/mobile_providers.dart
- lib/app/continuum_app.dart
- lib/features/pairing/**
- lib/features/sessions/**
- lib/features/approvals/**
- lib/features/inspect/**
- lib/features/settings/**
- integration_test/**

Check specifically:
1. Pairing: numeric/manual code goes to daemon backend and stores returned credentials.
2. Sessions: list/get/subscribe/send_input are live and WebSocket events flow into UI.
3. Chat: thinking/tool/terminal/approval events are distinguishable in UI.
4. Model switching: identify whether implemented or missing.
5. Hardcoded data: separate acceptable memory/demo mode from values that leak into live mode.
6. iOS test readiness: commands to run backend and Flutter on simulator with dart-defines.

Use no secrets in output. Write your report to qa-reports/agent-forge-blackbox-live-audit.md. Do not commit.
