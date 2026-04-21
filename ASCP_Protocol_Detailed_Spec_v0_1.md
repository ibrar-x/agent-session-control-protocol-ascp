# ASCP Protocol Specification v0.1 — Detailed Spec for Implementation

Version: 0.1.0  
Status: Draft Specification  
Date: 2026-04-21

## 1. Purpose

This document is the detailed, implementation-oriented specification for the **Agent Session & Control Protocol (ASCP)**.

This file is designed to be consumed by:
- protocol implementers
- SDK authors
- host daemon builders
- runtime adapter authors
- AI coding systems that will decompose the work into subtasks

This document is intentionally more exact than a PRD. It defines:
- canonical objects
- JSON schemas
- request and response contracts
- exact event payload shapes
- replay semantics
- auth hooks
- error catalog
- extension model
- compatibility expectations

This document does **not** define the product UI or business model.
It defines the protocol that products may build on top of.

---

## 2. Normative Language

The key words **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY** in this specification are to be interpreted as requirement levels.

- **MUST**: required for compliance
- **SHOULD**: recommended unless a strong reason exists not to
- **MAY**: optional

---

## 3. Protocol Scope

ASCP standardizes:
- host discovery
- runtime discovery
- capability advertisement
- session list/read/start/resume/stop
- input submission
- live event streaming
- event replay after reconnect
- approvals
- artifacts metadata
- diff metadata
- error semantics
- extension model
- auth integration points

ASCP does not standardize:
- model inference APIs
- prompt engineering format
- tool schemas
- agent planning internals
- UI widget libraries
- long-term memory representation
- vendor-specific billing or cloud execution

---

## 4. Canonical Data Model

### 4.1 Host

A **Host** represents a machine or server exposing one or more runtimes.

```json
{
  "id": "host_01",
  "name": "MacBook Pro",
  "platform": "macos",
  "arch": "arm64",
  "labels": {
    "environment": "local",
    "owner": "user"
  },
  "status": "online",
  "transports": ["websocket", "http_sse", "relay"]
}
```

Required fields:
- `id`
- `name`

Optional fields:
- `platform`
- `arch`
- `labels`
- `status`
- `transports`

Host status values:
- `online`
- `offline`
- `degraded`
- `unknown`

### 4.2 Runtime

A **Runtime** represents a concrete agent runtime available on a host.

```json
{
  "id": "codex_local",
  "kind": "codex",
  "display_name": "Codex CLI",
  "version": "0.1.x",
  "adapter_kind": "native",
  "capabilities": {
    "session_list": true,
    "session_resume": true,
    "session_start": true,
    "session_stop": true,
    "stream_events": true,
    "transcript_read": true,
    "message_send": true,
    "approval_requests": true,
    "approval_respond": true,
    "artifacts": true,
    "diffs": true,
    "terminal_passthrough": false,
    "notifications": true,
    "checkpoints": false,
    "replay": true,
    "multi_workspace": true
  }
}
```

Required fields:
- `id`
- `kind`
- `display_name`
- `version`

Optional fields:
- `adapter_kind`
- `capabilities`

Adapter kinds:
- `native`
- `wrapper`
- `pty`

### 4.3 Session

A **Session** is the primary control object in ASCP.

```json
{
  "id": "sess_abc123",
  "runtime_id": "codex_local",
  "title": "Fix failing Flutter integration tests",
  "workspace": "/Users/me/app",
  "status": "running",
  "created_at": "2026-04-21T10:00:00Z",
  "updated_at": "2026-04-21T10:12:00Z",
  "last_activity_at": "2026-04-21T10:12:00Z",
  "summary": "Working through checkout flow failures",
  "active_run_id": "run_9",
  "metadata": {
    "source": "codex"
  }
}
```

Required fields:
- `id`
- `runtime_id`
- `status`
- `created_at`
- `updated_at`

Optional fields:
- `title`
- `workspace`
- `last_activity_at`
- `summary`
- `active_run_id`
- `metadata`

Session status values:
- `idle`
- `running`
- `waiting_input`
- `waiting_approval`
- `completed`
- `failed`
- `stopped`
- `disconnected`

### 4.4 Run

A **Run** is a bounded execution phase within a session.

```json
{
  "id": "run_9",
  "session_id": "sess_abc123",
  "status": "running",
  "started_at": "2026-04-21T10:05:00Z",
  "ended_at": null,
  "exit_code": null
}
```

Required fields:
- `id`
- `session_id`
- `status`
- `started_at`

Optional fields:
- `ended_at`
- `exit_code`

Run status values:
- `starting`
- `running`
- `paused`
- `completed`
- `failed`
- `cancelled`

### 4.5 ApprovalRequest

An **ApprovalRequest** represents a structured human approval requirement.

```json
{
  "id": "apr_77",
  "session_id": "sess_abc123",
  "run_id": "run_9",
  "kind": "command",
  "status": "pending",
  "title": "Approve shell command",
  "description": "Agent wants to run flutter test integration_test",
  "risk_level": "medium",
  "payload": {
    "command": "flutter test integration_test",
    "cwd": "/Users/me/app"
  },
  "created_at": "2026-04-21T10:06:00Z",
  "resolved_at": null
}
```

Required fields:
- `id`
- `session_id`
- `kind`
- `status`
- `created_at`

Optional fields:
- `run_id`
- `title`
- `description`
- `risk_level`
- `payload`
- `resolved_at`

Approval kinds:
- `command`
- `file_write`
- `network`
- `tool`
- `generic`

Approval status values:
- `pending`
- `approved`
- `rejected`
- `expired`
- `cancelled`

Risk levels:
- `low`
- `medium`
- `high`
- `critical`

### 4.6 Artifact

An **Artifact** is metadata about an output produced by a session.

```json
{
  "id": "art_3",
  "session_id": "sess_abc123",
  "run_id": "run_9",
  "kind": "diff",
  "name": "CheckoutFlow.diff",
  "uri": "artifact://sess_abc123/art_3",
  "mime_type": "text/x-diff",
  "size_bytes": 4821,
  "created_at": "2026-04-21T10:10:00Z",
  "metadata": {
    "files_changed": 4
  }
}
```

Required fields:
- `id`
- `session_id`
- `kind`
- `created_at`

Optional fields:
- `run_id`
- `name`
- `uri`
- `mime_type`
- `size_bytes`
- `metadata`

Artifact kinds:
- `file`
- `diff`
- `patch`
- `image`
- `log`
- `report`
- `other`

### 4.7 DiffSummary

A **DiffSummary** provides normalized code-change metadata.

```json
{
  "session_id": "sess_abc123",
  "run_id": "run_9",
  "files_changed": 4,
  "insertions": 73,
  "deletions": 19,
  "files": [
    {
      "path": "lib/checkout/checkout_service.dart",
      "change_type": "modified",
      "insertions": 22,
      "deletions": 8
    }
  ]
}
```

Required fields:
- `session_id`
- `files_changed`

Optional fields:
- `run_id`
- `insertions`
- `deletions`
- `files`

File change types:
- `added`
- `modified`
- `deleted`
- `renamed`

### 4.8 EventEnvelope

All streamed events MUST be wrapped in an **EventEnvelope**.

```json
{
  "id": "evt_9001",
  "type": "message.assistant.delta",
  "ts": "2026-04-21T10:07:00Z",
  "session_id": "sess_abc123",
  "run_id": "run_9",
  "seq": 45,
  "payload": {
    "message_id": "msg_12",
    "delta": "I found the failing assertion..."
  }
}
```

Required fields:
- `id`
- `type`
- `ts`
- `session_id`
- `payload`

Optional fields:
- `run_id`
- `seq`

Rules:
- `seq` SHOULD be monotonic per session stream
- `id` MUST be unique within the session event stream
- `ts` MUST be RFC3339 UTC timestamp

---

## 5. Full JSON Schemas

### 5.1 Core entity schema

```json
{
  "$id": "https://ascp.dev/schema/v0.1/ascp-core.schema.json",
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "ASCP Core Entities",
  "$defs": {
    "Id": { "type": "string", "minLength": 1 },
    "Timestamp": { "type": "string", "format": "date-time" },
    "StringMap": {
      "type": "object",
      "additionalProperties": { "type": ["string", "number", "boolean", "null"] }
    },
    "Capabilities": {
      "type": "object",
      "properties": {
        "session_list": { "type": "boolean" },
        "session_resume": { "type": "boolean" },
        "session_start": { "type": "boolean" },
        "session_stop": { "type": "boolean" },
        "stream_events": { "type": "boolean" },
        "transcript_read": { "type": "boolean" },
        "message_send": { "type": "boolean" },
        "approval_requests": { "type": "boolean" },
        "approval_respond": { "type": "boolean" },
        "artifacts": { "type": "boolean" },
        "diffs": { "type": "boolean" },
        "terminal_passthrough": { "type": "boolean" },
        "notifications": { "type": "boolean" },
        "checkpoints": { "type": "boolean" },
        "replay": { "type": "boolean" },
        "multi_workspace": { "type": "boolean" }
      },
      "additionalProperties": true
    },
    "Host": {
      "type": "object",
      "required": ["id", "name"],
      "properties": {
        "id": { "$ref": "#/$defs/Id" },
        "name": { "type": "string" },
        "platform": { "type": "string" },
        "arch": { "type": "string" },
        "labels": { "$ref": "#/$defs/StringMap" },
        "status": {
          "type": "string",
          "enum": ["online", "offline", "degraded", "unknown"]
        },
        "transports": {
          "type": "array",
          "items": {
            "type": "string",
            "enum": ["websocket", "http_sse", "unix_socket", "named_pipe", "stdio", "relay"]
          }
        }
      },
      "additionalProperties": true
    },
    "Runtime": {
      "type": "object",
      "required": ["id", "kind", "display_name", "version"],
      "properties": {
        "id": { "$ref": "#/$defs/Id" },
        "kind": { "type": "string" },
        "display_name": { "type": "string" },
        "version": { "type": "string" },
        "adapter_kind": {
          "type": "string",
          "enum": ["native", "wrapper", "pty"]
        },
        "capabilities": { "$ref": "#/$defs/Capabilities" }
      },
      "additionalProperties": true
    },
    "Session": {
      "type": "object",
      "required": ["id", "runtime_id", "status", "created_at", "updated_at"],
      "properties": {
        "id": { "$ref": "#/$defs/Id" },
        "runtime_id": { "$ref": "#/$defs/Id" },
        "title": { "type": "string" },
        "workspace": { "type": "string" },
        "status": {
          "type": "string",
          "enum": ["idle", "running", "waiting_input", "waiting_approval", "completed", "failed", "stopped", "disconnected"]
        },
        "created_at": { "$ref": "#/$defs/Timestamp" },
        "updated_at": { "$ref": "#/$defs/Timestamp" },
        "last_activity_at": { "$ref": "#/$defs/Timestamp" },
        "summary": { "type": "string" },
        "active_run_id": { "$ref": "#/$defs/Id" },
        "metadata": { "$ref": "#/$defs/StringMap" }
      },
      "additionalProperties": true
    },
    "Run": {
      "type": "object",
      "required": ["id", "session_id", "status", "started_at"],
      "properties": {
        "id": { "$ref": "#/$defs/Id" },
        "session_id": { "$ref": "#/$defs/Id" },
        "status": {
          "type": "string",
          "enum": ["starting", "running", "paused", "completed", "failed", "cancelled"]
        },
        "started_at": { "$ref": "#/$defs/Timestamp" },
        "ended_at": { "$ref": "#/$defs/Timestamp" },
        "exit_code": { "type": ["integer", "null"] }
      },
      "additionalProperties": true
    },
    "ApprovalRequest": {
      "type": "object",
      "required": ["id", "session_id", "kind", "status", "created_at"],
      "properties": {
        "id": { "$ref": "#/$defs/Id" },
        "session_id": { "$ref": "#/$defs/Id" },
        "run_id": { "$ref": "#/$defs/Id" },
        "kind": {
          "type": "string",
          "enum": ["command", "file_write", "network", "tool", "generic"]
        },
        "status": {
          "type": "string",
          "enum": ["pending", "approved", "rejected", "expired", "cancelled"]
        },
        "title": { "type": "string" },
        "description": { "type": "string" },
        "risk_level": {
          "type": "string",
          "enum": ["low", "medium", "high", "critical"]
        },
        "payload": { "type": "object", "additionalProperties": true },
        "created_at": { "$ref": "#/$defs/Timestamp" },
        "resolved_at": { "$ref": "#/$defs/Timestamp" }
      },
      "additionalProperties": true
    },
    "Artifact": {
      "type": "object",
      "required": ["id", "session_id", "kind", "created_at"],
      "properties": {
        "id": { "$ref": "#/$defs/Id" },
        "session_id": { "$ref": "#/$defs/Id" },
        "run_id": { "$ref": "#/$defs/Id" },
        "kind": {
          "type": "string",
          "enum": ["file", "diff", "patch", "image", "log", "report", "other"]
        },
        "name": { "type": "string" },
        "uri": { "type": "string" },
        "mime_type": { "type": "string" },
        "size_bytes": { "type": "integer" },
        "created_at": { "$ref": "#/$defs/Timestamp" },
        "metadata": { "$ref": "#/$defs/StringMap" }
      },
      "additionalProperties": true
    },
    "DiffSummary": {
      "type": "object",
      "required": ["session_id", "files_changed"],
      "properties": {
        "session_id": { "$ref": "#/$defs/Id" },
        "run_id": { "$ref": "#/$defs/Id" },
        "files_changed": { "type": "integer" },
        "insertions": { "type": "integer" },
        "deletions": { "type": "integer" },
        "files": {
          "type": "array",
          "items": {
            "type": "object",
            "required": ["path", "change_type"],
            "properties": {
              "path": { "type": "string" },
              "change_type": {
                "type": "string",
                "enum": ["added", "modified", "deleted", "renamed"]
              },
              "insertions": { "type": "integer" },
              "deletions": { "type": "integer" }
            },
            "additionalProperties": true
          }
        }
      },
      "additionalProperties": true
    },
    "EventEnvelope": {
      "type": "object",
      "required": ["id", "type", "ts", "session_id", "payload"],
      "properties": {
        "id": { "$ref": "#/$defs/Id" },
        "type": { "type": "string" },
        "ts": { "$ref": "#/$defs/Timestamp" },
        "session_id": { "$ref": "#/$defs/Id" },
        "run_id": { "$ref": "#/$defs/Id" },
        "seq": { "type": "integer" },
        "payload": { "type": "object", "additionalProperties": true }
      },
      "additionalProperties": true
    }
  }
}
```

### 5.2 Capability document schema

```json
{
  "$id": "https://ascp.dev/schema/v0.1/ascp-capabilities.schema.json",
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "required": ["protocol_version", "host", "runtimes", "transports", "capabilities"],
  "properties": {
    "protocol_version": { "type": "string" },
    "host": { "$ref": "ascp-core.schema.json#/$defs/Host" },
    "runtimes": {
      "type": "array",
      "items": { "$ref": "ascp-core.schema.json#/$defs/Runtime" }
    },
    "transports": {
      "type": "array",
      "items": {
        "type": "string",
        "enum": ["websocket", "http_sse", "unix_socket", "named_pipe", "stdio", "relay"]
      }
    },
    "capabilities": { "$ref": "ascp-core.schema.json#/$defs/Capabilities" },
    "extensions": {
      "type": "array",
      "items": { "type": "string" }
    }
  },
  "additionalProperties": true
}
```

### 5.3 Error schema

```json
{
  "$id": "https://ascp.dev/schema/v0.1/ascp-errors.schema.json",
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "required": ["code", "message", "retryable"],
  "properties": {
    "code": { "type": "string" },
    "message": { "type": "string" },
    "retryable": { "type": "boolean" },
    "details": {
      "type": ["object", "null"],
      "additionalProperties": true
    },
    "correlation_id": { "type": "string" }
  },
  "additionalProperties": true
}
```

---

## 6. Request/Response Envelope Model

ASCP SHOULD use JSON-RPC 2.0 over WebSocket or HTTP where request/response semantics are needed.

### Request envelope

```json
{
  "jsonrpc": "2.0",
  "id": "req_123",
  "method": "sessions.get",
  "params": {
    "session_id": "sess_abc123"
  }
}
```

### Success response envelope

```json
{
  "jsonrpc": "2.0",
  "id": "req_123",
  "result": {
    "session": {
      "id": "sess_abc123",
      "runtime_id": "codex_local",
      "status": "running",
      "created_at": "2026-04-21T10:00:00Z",
      "updated_at": "2026-04-21T10:12:00Z"
    }
  }
}
```

### Error response envelope

```json
{
  "jsonrpc": "2.0",
  "id": "req_123",
  "error": {
    "code": "NOT_FOUND",
    "message": "Session not found",
    "retryable": false,
    "details": {
      "session_id": "sess_missing"
    },
    "correlation_id": "corr_99"
  }
}
```

Rules:
- request `id` MUST be echoed in success or error response
- notifications MAY omit `id`
- `result` and `error` MUST NOT coexist

---

## 7. Method-by-Method Contracts

### 7.1 `capabilities.get`
Purpose: returns the capability document for the host and runtimes.

Request:
```json
{
  "jsonrpc": "2.0",
  "id": "req_cap_1",
  "method": "capabilities.get",
  "params": {}
}
```

Success response:
```json
{
  "jsonrpc": "2.0",
  "id": "req_cap_1",
  "result": {
    "protocol_version": "0.1.0",
    "host": {
      "id": "host_01",
      "name": "MacBook Pro"
    },
    "transports": ["websocket", "relay"],
    "capabilities": {
      "session_list": true,
      "session_resume": true,
      "stream_events": true
    },
    "runtimes": []
  }
}
```

Errors:
- `UNAUTHORIZED`
- `INTERNAL_ERROR`

### 7.2 `hosts.get`
Purpose: returns host metadata.

Request params: empty object.

Success result:
```json
{
  "host": {
    "id": "host_01",
    "name": "MacBook Pro",
    "platform": "macos",
    "arch": "arm64"
  }
}
```

### 7.3 `runtimes.list`
Purpose: returns all runtimes visible on the host.

Optional request params:
- `kind`
- `adapter_kind`

Success result:
```json
{
  "runtimes": [
    {
      "id": "codex_local",
      "kind": "codex",
      "display_name": "Codex CLI",
      "version": "0.1.x"
    }
  ]
}
```

### 7.4 `sessions.list`
Purpose: returns sessions, optionally filtered.

Optional request params:
- `runtime_id`
- `status`
- `workspace`
- `updated_after`
- `search_text`
- `limit`
- `cursor`

Request example:
```json
{
  "jsonrpc": "2.0",
  "id": "req_list_1",
  "method": "sessions.list",
  "params": {
    "runtime_id": "codex_local",
    "status": "running",
    "limit": 20
  }
}
```

Success result:
```json
{
  "sessions": [
    {
      "id": "sess_abc123",
      "runtime_id": "codex_local",
      "title": "Fix failing Flutter integration tests",
      "status": "running",
      "created_at": "2026-04-21T10:00:00Z",
      "updated_at": "2026-04-21T10:12:00Z"
    }
  ],
  "next_cursor": null
}
```

Errors:
- `UNAUTHORIZED`
- `FORBIDDEN`
- `INVALID_REQUEST`
- `ADAPTER_ERROR`
- `INTERNAL_ERROR`

### 7.5 `sessions.get`
Purpose: returns a single normalized session object.

Required params:
- `session_id`

Optional params:
- `include_runs`
- `include_pending_approvals`

Success result:
```json
{
  "session": {
    "id": "sess_abc123",
    "runtime_id": "codex_local",
    "title": "Fix failing Flutter integration tests",
    "status": "running",
    "created_at": "2026-04-21T10:00:00Z",
    "updated_at": "2026-04-21T10:12:00Z"
  },
  "runs": [],
  "pending_approvals": []
}
```

Errors:
- `NOT_FOUND`
- `UNAUTHORIZED`
- `FORBIDDEN`
- `ADAPTER_ERROR`

### 7.6 `sessions.start`
Purpose: starts a new session.

Required params:
- `runtime_id`

Optional params:
- `workspace`
- `title`
- `initial_prompt`
- `metadata`

Request example:
```json
{
  "jsonrpc": "2.0",
  "id": "req_start_1",
  "method": "sessions.start",
  "params": {
    "runtime_id": "codex_local",
    "workspace": "/Users/me/app",
    "title": "Investigate checkout test failures",
    "initial_prompt": "Find the cause of checkout flow integration test failures."
  }
}
```

Success result:
```json
{
  "session": {
    "id": "sess_new_1",
    "runtime_id": "codex_local",
    "title": "Investigate checkout test failures",
    "workspace": "/Users/me/app",
    "status": "running",
    "created_at": "2026-04-21T10:20:00Z",
    "updated_at": "2026-04-21T10:20:00Z"
  }
}
```

Errors:
- `UNAUTHORIZED`
- `FORBIDDEN`
- `INVALID_REQUEST`
- `UNSUPPORTED`
- `ADAPTER_ERROR`
- `RUNTIME_ERROR`

### 7.7 `sessions.resume`
Purpose: resumes or reattaches to an existing session.

Required params:
- `session_id`

Optional params:
- `runtime_id`

Success result:
```json
{
  "session": {
    "id": "sess_abc123",
    "runtime_id": "codex_local",
    "status": "running",
    "created_at": "2026-04-21T10:00:00Z",
    "updated_at": "2026-04-21T10:21:00Z"
  },
  "snapshot_emitted": true,
  "replay_supported": true
}
```

Errors:
- `NOT_FOUND`
- `FORBIDDEN`
- `UNSUPPORTED`
- `ADAPTER_ERROR`
- `RUNTIME_ERROR`

### 7.8 `sessions.stop`
Purpose: stops or cancels a session.

Required params:
- `session_id`

Optional params:
- `mode` (`graceful` or `force`)
- `reason`

Success result:
```json
{
  "session_id": "sess_abc123",
  "status": "stopped"
}
```

Errors:
- `NOT_FOUND`
- `FORBIDDEN`
- `UNSUPPORTED`
- `RUNTIME_ERROR`

### 7.9 `sessions.send_input`
Purpose: sends user input into a session.

Required params:
- `session_id`
- `input`

Optional params:
- `input_kind`
- `metadata`

Input kinds:
- `text`
- `instruction`
- `reply`
- `control`

Request example:
```json
{
  "jsonrpc": "2.0",
  "id": "req_input_1",
  "method": "sessions.send_input",
  "params": {
    "session_id": "sess_abc123",
    "input": "Continue, but focus on the checkout API mock.",
    "input_kind": "instruction"
  }
}
```

Success result:
```json
{
  "accepted": true,
  "session_id": "sess_abc123"
}
```

Errors:
- `NOT_FOUND`
- `FORBIDDEN`
- `UNSUPPORTED`
- `RUNTIME_ERROR`

### 7.10 `sessions.subscribe`
Purpose: registers a live event subscription.

Required params:
- `session_id`

Optional params:
- `from_seq`
- `from_event_id`
- `include_snapshot`

Success result:
```json
{
  "subscription_id": "sub_01",
  "session_id": "sess_abc123",
  "snapshot_emitted": true
}
```

Errors:
- `NOT_FOUND`
- `FORBIDDEN`
- `UNSUPPORTED`
- `TRANSIENT_UNAVAILABLE`

After a successful call, event envelopes MUST begin streaming on the active transport.

### 7.11 `sessions.unsubscribe`
Purpose: ends a live event subscription.

Required params:
- `subscription_id`

Success result:
```json
{
  "subscription_id": "sub_01",
  "unsubscribed": true
}
```

### 7.12 `approvals.list`
Purpose: returns approval requests.

Optional params:
- `session_id`
- `status`
- `limit`
- `cursor`

Success result:
```json
{
  "approvals": [
    {
      "id": "apr_77",
      "session_id": "sess_abc123",
      "kind": "command",
      "status": "pending",
      "created_at": "2026-04-21T10:06:00Z"
    }
  ],
  "next_cursor": null
}
```

### 7.13 `approvals.respond`
Purpose: approves or rejects a pending approval.

Required params:
- `approval_id`
- `decision`

Optional params:
- `note`

Decision values:
- `approved`
- `rejected`

Request example:
```json
{
  "jsonrpc": "2.0",
  "id": "req_appr_1",
  "method": "approvals.respond",
  "params": {
    "approval_id": "apr_77",
    "decision": "approved",
    "note": "Looks safe"
  }
}
```

Success result:
```json
{
  "approval_id": "apr_77",
  "status": "approved"
}
```

Errors:
- `NOT_FOUND`
- `FORBIDDEN`
- `CONFLICT`
- `RUNTIME_ERROR`

### 7.14 `artifacts.list`
Purpose: lists artifact metadata for a session.

Required params:
- `session_id`

Optional params:
- `run_id`
- `kind`

Success result:
```json
{
  "artifacts": [
    {
      "id": "art_3",
      "session_id": "sess_abc123",
      "kind": "diff",
      "created_at": "2026-04-21T10:10:00Z"
    }
  ]
}
```

### 7.15 `artifacts.get`
Purpose: returns artifact metadata and access information.

Required params:
- `artifact_id`

Success result:
```json
{
  "artifact": {
    "id": "art_3",
    "session_id": "sess_abc123",
    "kind": "diff",
    "uri": "artifact://sess_abc123/art_3",
    "mime_type": "text/x-diff",
    "created_at": "2026-04-21T10:10:00Z"
  }
}
```

### 7.16 `diffs.get`
Purpose: returns normalized diff summary when available.

Required params:
- `session_id`

Optional params:
- `run_id`

Success result:
```json
{
  "diff": {
    "session_id": "sess_abc123",
    "run_id": "run_9",
    "files_changed": 4,
    "insertions": 73,
    "deletions": 19,
    "files": []
  }
}
```

Errors:
- `UNSUPPORTED`
- `NOT_FOUND`
- `ADAPTER_ERROR`

---

## 8. Exact Event Payload Definitions

All events MUST be sent as `EventEnvelope` objects with exact payload shapes per event type.

### 8.1 Session lifecycle events

#### `session.created`
```json
{
  "session": {
    "id": "sess_abc123",
    "runtime_id": "codex_local",
    "status": "idle",
    "created_at": "2026-04-21T10:00:00Z",
    "updated_at": "2026-04-21T10:00:00Z"
  }
}
```

#### `session.updated`
```json
{
  "session": {
    "id": "sess_abc123",
    "runtime_id": "codex_local",
    "status": "running",
    "updated_at": "2026-04-21T10:02:00Z"
  },
  "changed_fields": ["status", "updated_at"]
}
```

#### `session.status_changed`
```json
{
  "from": "running",
  "to": "waiting_approval"
}
```

#### `session.deleted`
```json
{
  "reason": "runtime_cleanup"
}
```

### 8.2 Run lifecycle events

#### `run.started`
```json
{
  "run": {
    "id": "run_9",
    "session_id": "sess_abc123",
    "status": "running",
    "started_at": "2026-04-21T10:05:00Z"
  }
}
```

#### `run.paused`
```json
{
  "run_id": "run_9",
  "reason": "waiting_for_input"
}
```

#### `run.resumed`
```json
{
  "run_id": "run_9",
  "reason": "user_input_received"
}
```

#### `run.completed`
```json
{
  "run_id": "run_9",
  "ended_at": "2026-04-21T10:30:00Z",
  "exit_code": 0
}
```

#### `run.failed`
```json
{
  "run_id": "run_9",
  "ended_at": "2026-04-21T10:30:00Z",
  "error_code": "RUNTIME_ERROR",
  "message": "Subprocess exited unexpectedly"
}
```

#### `run.cancelled`
```json
{
  "run_id": "run_9",
  "ended_at": "2026-04-21T10:31:00Z",
  "reason": "user_stop"
}
```

### 8.3 Transcript events

#### `message.user`
```json
{
  "message_id": "msg_u_1",
  "content": "Continue, but focus on the checkout API mock."
}
```

#### `message.assistant.started`
```json
{
  "message_id": "msg_a_1"
}
```

#### `message.assistant.delta`
```json
{
  "message_id": "msg_a_1",
  "delta": "I found the source of the failure..."
}
```

#### `message.assistant.completed`
```json
{
  "message_id": "msg_a_1",
  "content": "I found the source of the failure in the mocked checkout response."
}
```

#### `message.system`
```json
{
  "message_id": "msg_s_1",
  "content": "Session resumed from remote client."
}
```

### 8.4 Tool activity events

#### `tool.started`
```json
{
  "tool_call_id": "tool_55",
  "tool_name": "shell",
  "summary": "Running flutter test integration_test"
}
```

#### `tool.stdout`
```json
{
  "tool_call_id": "tool_55",
  "chunk": "00:01 +1: loading test file..."
}
```

#### `tool.stderr`
```json
{
  "tool_call_id": "tool_55",
  "chunk": "Warning: deprecated API used"
}
```

#### `tool.completed`
```json
{
  "tool_call_id": "tool_55",
  "exit_code": 0
}
```

#### `tool.failed`
```json
{
  "tool_call_id": "tool_55",
  "exit_code": 1,
  "message": "Command failed"
}
```

### 8.5 Terminal fallback events

#### `terminal.opened`
```json
{
  "terminal_id": "pty_1",
  "cols": 120,
  "rows": 36
}
```

#### `terminal.output`
```json
{
  "terminal_id": "pty_1",
  "chunk": "assistant> inspecting workspace..."
}
```

#### `terminal.closed`
```json
{
  "terminal_id": "pty_1",
  "exit_code": 0
}
```

#### `terminal.resize_requested`
```json
{
  "terminal_id": "pty_1",
  "cols": 140,
  "rows": 40
}
```

### 8.6 Approval events

#### `approval.requested`
```json
{
  "approval": {
    "id": "apr_77",
    "session_id": "sess_abc123",
    "run_id": "run_9",
    "kind": "command",
    "status": "pending",
    "title": "Approve shell command",
    "description": "Agent wants to run flutter test integration_test",
    "risk_level": "medium",
    "payload": {
      "command": "flutter test integration_test",
      "cwd": "/Users/me/app"
    },
    "created_at": "2026-04-21T10:06:00Z"
  }
}
```

#### `approval.updated`
```json
{
  "approval_id": "apr_77",
  "changed_fields": ["status"]
}
```

#### `approval.approved`
```json
{
  "approval_id": "apr_77",
  "resolved_at": "2026-04-21T10:07:00Z",
  "actor_id": "device_user_1"
}
```

#### `approval.rejected`
```json
{
  "approval_id": "apr_77",
  "resolved_at": "2026-04-21T10:07:00Z",
  "actor_id": "device_user_1",
  "note": "Do not run full integration tests now"
}
```

#### `approval.expired`
```json
{
  "approval_id": "apr_77",
  "expired_at": "2026-04-21T10:10:00Z"
}
```

### 8.7 Artifact and diff events

#### `artifact.created`
```json
{
  "artifact": {
    "id": "art_3",
    "session_id": "sess_abc123",
    "kind": "report",
    "name": "FailureSummary.md",
    "created_at": "2026-04-21T10:12:00Z"
  }
}
```

#### `artifact.updated`
```json
{
  "artifact_id": "art_3",
  "changed_fields": ["metadata"]
}
```

#### `diff.ready`
```json
{
  "diff": {
    "session_id": "sess_abc123",
    "run_id": "run_9",
    "files_changed": 4,
    "insertions": 73,
    "deletions": 19
  }
}
```

#### `diff.updated`
```json
{
  "session_id": "sess_abc123",
  "run_id": "run_9",
  "changed_fields": ["files_changed", "insertions", "deletions"]
}
```

### 8.8 Sync and connectivity events

#### `connection.state_changed`
```json
{
  "state": "reconnected"
}
```

Allowed values:
- `connected`
- `disconnected`
- `reconnecting`
- `reconnected`

#### `sync.snapshot`
```json
{
  "session": {
    "id": "sess_abc123",
    "runtime_id": "codex_local",
    "status": "running",
    "created_at": "2026-04-21T10:00:00Z",
    "updated_at": "2026-04-21T10:21:00Z"
  },
  "active_run": {
    "id": "run_9",
    "session_id": "sess_abc123",
    "status": "running",
    "started_at": "2026-04-21T10:05:00Z"
  },
  "pending_approvals": []
}
```

#### `sync.replayed`
```json
{
  "from_seq": 31,
  "to_seq": 45,
  "event_count": 15
}
```

#### `sync.cursor_advanced`
```json
{
  "cursor": "seq:45"
}
```

### 8.9 Error events

#### `error.transient`
```json
{
  "code": "TRANSIENT_UNAVAILABLE",
  "message": "Temporary adapter disconnection"
}
```

#### `error.fatal`
```json
{
  "code": "RUNTIME_ERROR",
  "message": "Runtime became unavailable"
}
```

---

## 9. Replay Semantics

Replay is critical for mobile and remote control.

### 9.1 Goals
Replay exists to support:
- mobile app suspend/resume
- network interruptions
- host reconnect
- relay reconnect
- multi-device continuity

### 9.2 Requirements
- implementations with `replay=true` capability MUST support replay by `from_seq` or equivalent cursor
- replay MUST preserve original event ordering within a session where ordering exists
- replay MUST NOT mutate historical event content
- implementations MAY combine snapshot + replay
- replay SHOULD be bounded by retention policy

### 9.3 Recommended replay model
1. client reconnects
2. client calls `sessions.subscribe` with `from_seq` or `from_event_id`
3. server emits `sync.snapshot` if requested or required
4. server emits replayed events in order
5. server emits `sync.replayed`
6. server continues live events

### 9.4 Sequence rules
- `seq` SHOULD be monotonic per session
- `seq` SHOULD NOT be reused
- if a runtime cannot provide stable `seq`, the host SHOULD synthesize it
- if neither runtime nor host can provide replay, capability `replay` MUST be false

### 9.5 Snapshot rules
A snapshot SHOULD include:
- current session state
- current active run if any
- current pending approvals
- optional summary state

A snapshot MUST NOT pretend to be historical replay data.

### 9.6 Cursor rules
Clients MAY use:
- `from_seq`
- `from_event_id`
- implementation-defined opaque cursor

If opaque cursor is supported, it SHOULD be emitted via `sync.cursor_advanced`.

### 9.7 Retention
Replay support MAY be limited by retention policy.
When data is no longer replayable, server SHOULD return:
- snapshot only
or
- `TRANSIENT_UNAVAILABLE` or `UNSUPPORTED` with explanatory details

---

## 10. Auth Hooks

ASCP does not mandate one auth vendor or token format, but it does define integration expectations.

### 10.1 Goals
- authenticate clients
- authorize sensitive actions
- attribute approvals
- support audit logging
- support device identity

### 10.2 Required concepts
Implementations SHOULD support:
- actor identity
- device identity
- scopes or permissions
- correlation IDs
- audit attribution

### 10.3 Recommended auth model
Recommended:
- bearer token authentication
- short-lived access token
- optional long-lived device credential or refresh credential
- host-scoped permissions

### 10.4 Recommended scopes
- `read:capabilities`
- `read:hosts`
- `read:runtimes`
- `read:sessions`
- `write:sessions`
- `read:approvals`
- `write:approvals`
- `read:artifacts`
- `admin:host`

### 10.5 Sensitive methods
The following SHOULD require explicit control scope:
- `sessions.start`
- `sessions.resume`
- `sessions.stop`
- `sessions.send_input`
- `approvals.respond`

The following SHOULD require explicit read scope:
- `sessions.list`
- `sessions.get`
- `approvals.list`
- `artifacts.list`
- `artifacts.get`
- `diffs.get`

### 10.6 Actor attribution
Implementations SHOULD associate control actions with:
- `actor_id`
- `device_id`
- `correlation_id`

These SHOULD be available to audit sinks and MAY appear in internal event metadata.

### 10.7 Auth failure behavior
Unauthorized or forbidden method calls MUST return:
- `UNAUTHORIZED` when auth is missing or invalid
- `FORBIDDEN` when auth is valid but insufficient

---

## 11. Error Catalog

### `INVALID_REQUEST`
Use when request shape or semantics are invalid.

Retryable: false

### `UNAUTHORIZED`
Use when authentication is missing, expired, or invalid.

Retryable: false, unless caller refreshes credentials

### `FORBIDDEN`
Use when caller lacks permission.

Retryable: false

### `NOT_FOUND`
Use when requested session, approval, artifact, or runtime does not exist.

Retryable: false

### `CONFLICT`
Use when object state makes the action invalid.
Examples:
- approval already resolved
- session already stopped

Retryable: false

### `UNSUPPORTED`
Use when runtime or host does not support the requested method or feature.

Retryable: false

### `RATE_LIMITED`
Use when caller exceeds quotas or safety throttles.

Retryable: true

### `ADAPTER_ERROR`
Use when adapter mapping or integration logic fails.

Retryable: depends on details

### `RUNTIME_ERROR`
Use when underlying runtime returns a failure.

Retryable: depends on runtime

### `TRANSIENT_UNAVAILABLE`
Use when operation might succeed later.
Examples:
- temporary disconnect
- replay store warming
- runtime momentarily unavailable

Retryable: true

### `INTERNAL_ERROR`
Use when host-side processing failed unexpectedly.

Retryable: may be true or false depending on details, but default false unless explicitly stated

Example:
```json
{
  "code": "CONFLICT",
  "message": "Approval already resolved",
  "retryable": false,
  "details": {
    "approval_id": "apr_77",
    "status": "approved"
  },
  "correlation_id": "corr_123"
}
```

---

## 12. Extension Model

Extensions are allowed, but the core spec must remain stable.

### 12.1 Extension rules
- extensions MAY add new methods
- extensions MAY add new event types
- extensions MAY add additional fields
- extensions MUST NOT redefine core field meanings
- extensions SHOULD use namespacing

### 12.2 Recommended namespacing
- methods: `x.vendor.method_name`
- event types: `x.vendor.event_name`
- capability flags: `x_vendor_feature`

Examples:
- `x.codex.thread_checkpoint`
- `x.enterprise.policy_violation`
- `x_vendor_terminal_replay`

### 12.3 Capability advertisement for extensions
Capability documents SHOULD expose active extensions via:
```json
{
  "extensions": [
    "x.codex",
    "x.enterprise.audit"
  ]
}
```

### 12.4 Unknown extension behavior
Clients MUST ignore unknown extension fields and unknown extension events unless explicitly configured to fail.

---

## 13. Compatibility Levels

### ASCP Core Compatible
Requires:
- capability document
- runtime listing
- session list
- session get
- event envelope support

### ASCP Interactive
Requires:
- start or resume
- send input
- subscribe/unsubscribe

### ASCP Approval-Aware
Requires:
- approval events
- approvals.list
- approvals.respond

### ASCP Artifact-Aware
Requires:
- artifacts.list
- artifacts.get and/or diffs.get

### ASCP Replay-Capable
Requires:
- replay capability flag
- from-seq or equivalent replay support
- snapshot and replay semantics as specified

---

## 14. Conformance Requirements

A conformant implementation SHOULD publish:
- capability document
- schema-valid examples
- method compatibility list
- event support list
- extension declarations
- retention and replay behavior notes

A conformant test suite SHOULD verify:
- schema correctness
- method request validation
- method response validation
- event payload validation
- replay ordering
- auth failure handling
- extension ignore behavior

---

## 15. Suggested Repository Layout for the Protocol

```text
ascp-protocol/
  README.md
  LICENSE
  CHANGELOG.md
  spec/
    ascp-spec.md
    ascp-core.schema.json
    ascp-capabilities.schema.json
    ascp-errors.schema.json
    methods.md
    events.md
    replay.md
    auth-hooks.md
    extensions.md
    compatibility.md
  examples/
    capabilities/
    requests/
    responses/
    events/
    errors/
  conformance/
    fixtures/
    validators/
    tests/
  mock-server/
```

---

## 16. Implementation Breakdown for AI Coding Systems

An AI coder can break the protocol work into these tasks:

### Task group 1: schema foundation
- create `ascp-core.schema.json`
- create `ascp-capabilities.schema.json`
- create `ascp-errors.schema.json`
- validate all examples against schemas

### Task group 2: method contracts
- implement request/response models for every method
- add request validation
- add error mapping

### Task group 3: event contracts
- create exact payload interfaces for all core events
- add event validators
- add event example fixtures

### Task group 4: replay
- define cursor model
- implement sequence handling
- implement snapshot + replay flow
- add replay conformance tests

### Task group 5: auth hooks
- define auth middleware interfaces
- define scope checks per method
- define actor/device attribution hooks

### Task group 6: extensions
- add namespaced extension handling
- verify unknown extensions are ignored safely

### Task group 7: conformance
- build mock server
- build compatibility tests
- build golden event stream fixtures

---

## 17. Definition of Done

The detailed protocol spec is implementation-ready when:
- all core objects have schemas
- all methods have exact request and response contracts
- all core events have exact payload definitions
- replay semantics are documented and testable
- auth hooks are documented
- error catalog is frozen
- extension rules are frozen
- compatibility levels are defined
- a mock server can be built from this spec without guessing behavior

---

## 18. Final Recommendation

This specification should now be treated as the source of truth for protocol work.

Do not expand scope before:
- schemas validate
- method contracts are implemented
- event payloads are locked
- replay behavior is tested

That is how ASCP becomes a real protocol and not just a concept.
