import type { ErrorObject as AjvErrorObject } from "ajv";

import {
  ASCP_CORE_EVENT_TYPES,
  type CoreEventEnvelope,
  type CoreEventType
} from "../events/types.js";
import { type CoreMethodName } from "../methods/types.js";
import type { EventEnvelope } from "../models/types.js";
import {
  CAPABILITIES_SCHEMA_ID,
  CORE_SCHEMA_ID,
  ERRORS_SCHEMA_ID,
  EVENTS_SCHEMA_ID,
  METHODS_SCHEMA_ID,
  getValidator
} from "./schema-registry.js";
import {
  AscpValidationError,
  type CoreEntityMap,
  type CoreEntityName,
  type CoreMethodResponse,
  type ValidationFailure,
  type ValidationIssue,
  type ValidationResult,
  type ValidationSuccess
} from "./types.js";

const CORE_ENTITY_SCHEMA_REFS: Record<CoreEntityName, string> = {
  Capabilities: `${CORE_SCHEMA_ID}#/$defs/Capabilities`,
  CapabilityDocument: CAPABILITIES_SCHEMA_ID,
  Host: `${CORE_SCHEMA_ID}#/$defs/Host`,
  Runtime: `${CORE_SCHEMA_ID}#/$defs/Runtime`,
  Session: `${CORE_SCHEMA_ID}#/$defs/Session`,
  Run: `${CORE_SCHEMA_ID}#/$defs/Run`,
  ApprovalRequest: `${CORE_SCHEMA_ID}#/$defs/ApprovalRequest`,
  InputRequest: `${CORE_SCHEMA_ID}#/$defs/InputRequest`,
  Artifact: `${CORE_SCHEMA_ID}#/$defs/Artifact`,
  DiffSummary: `${CORE_SCHEMA_ID}#/$defs/DiffSummary`,
  EventEnvelope: `${CORE_SCHEMA_ID}#/$defs/EventEnvelope`,
  ErrorObject: ERRORS_SCHEMA_ID
};

const CORE_EVENT_TYPE_SET = new Set<string>(ASCP_CORE_EVENT_TYPES);

function toPascalCase(value: string): string {
  return value
    .split(/[._]/u)
    .filter(Boolean)
    .map((part) => part.charAt(0).toUpperCase() + part.slice(1))
    .join("");
}

function toIssue(error: AjvErrorObject): ValidationIssue {
  return {
    keyword: error.keyword,
    path: error.instancePath || "/",
    schemaPath: error.schemaPath,
    message: error.message ?? "Validation failed.",
    params: error.params
  };
}

function createValidationError(
  target: string,
  issues: ValidationIssue[]
): AscpValidationError {
  return new AscpValidationError(target, issues, formatValidationIssues(target, issues));
}

function createFailure(target: string, issues: ValidationIssue[]): ValidationFailure {
  return {
    success: false,
    error: createValidationError(target, issues)
  };
}

function createSuccess<T>(data: T): ValidationSuccess<T> {
  return {
    success: true,
    data
  };
}

function validateAgainstSchema<T>(
  schemaRef: string,
  target: string,
  value: unknown
): ValidationResult<T> {
  const validator = getValidator(schemaRef);
  const valid = validator(value);

  if (valid) {
    return createSuccess(value as T);
  }

  return createFailure(target, (validator.errors ?? []).map(toIssue));
}

function methodSchemaStem(method: CoreMethodName): string {
  return toPascalCase(method);
}

function eventSchemaStem(eventType: CoreEventType): string {
  return `${toPascalCase(eventType)}Event`;
}

function isEventEnvelope(value: unknown): value is EventEnvelope {
  return typeof value === "object" && value !== null;
}

export function formatValidationIssues(
  target: string,
  issues: readonly ValidationIssue[]
): string {
  const detailLines = issues.map(
    (issue) =>
      `${issue.path} [${issue.keyword}] ${issue.message} (${issue.schemaPath})`
  );

  return [`ASCP validation failed for ${target}.`, ...detailLines].join("\n");
}

export function safeParseCoreEntity<TEntity extends CoreEntityName>(
  entity: TEntity,
  value: unknown
): ValidationResult<CoreEntityMap[TEntity]> {
  return validateAgainstSchema<CoreEntityMap[TEntity]>(
    CORE_ENTITY_SCHEMA_REFS[entity],
    entity,
    value
  );
}

export function parseCoreEntity<TEntity extends CoreEntityName>(
  entity: TEntity,
  value: unknown
): CoreEntityMap[TEntity] {
  const result = safeParseCoreEntity(entity, value);

  if (!result.success) {
    throw result.error;
  }

  return result.data;
}

export function assertCoreEntity<TEntity extends CoreEntityName>(
  entity: TEntity,
  value: unknown
): asserts value is CoreEntityMap[TEntity] {
  parseCoreEntity(entity, value);
}

export function safeParseEventEnvelope(
  value: unknown
): ValidationResult<EventEnvelope> {
  return validateAgainstSchema<EventEnvelope>(
    `${CORE_SCHEMA_ID}#/$defs/EventEnvelope`,
    "EventEnvelope",
    value
  );
}

export function parseEventEnvelope(value: unknown): EventEnvelope {
  const result = safeParseEventEnvelope(value);

  if (!result.success) {
    throw result.error;
  }

  return result.data;
}

export function assertEventEnvelope(value: unknown): asserts value is EventEnvelope {
  parseEventEnvelope(value);
}

export function safeParseCoreEventEnvelope(
  value: unknown
): ValidationResult<CoreEventEnvelope> {
  const envelopeResult = safeParseEventEnvelope(value);

  if (!envelopeResult.success) {
    return envelopeResult;
  }

  if (!isEventEnvelope(value) || !CORE_EVENT_TYPE_SET.has(value.type)) {
    return createFailure("core event envelope", [
      {
        keyword: "enum",
        path: "/type",
        schemaPath: `${EVENTS_SCHEMA_ID}#/$defs/AnyEvent`,
        message: "must be one of the supported core event types",
        params: {
          allowedValues: ASCP_CORE_EVENT_TYPES
        }
      }
    ]);
  }

  const coreEventType = value.type as CoreEventType;

  return validateAgainstSchema<CoreEventEnvelope>(
    `${EVENTS_SCHEMA_ID}#/$defs/${eventSchemaStem(coreEventType)}`,
    `${coreEventType} event`,
    value
  );
}

export function parseCoreEventEnvelope(value: unknown): CoreEventEnvelope {
  const result = safeParseCoreEventEnvelope(value);

  if (!result.success) {
    throw result.error;
  }

  return result.data;
}

export function assertCoreEventEnvelope(
  value: unknown
): asserts value is CoreEventEnvelope {
  parseCoreEventEnvelope(value);
}

export function safeParseMethodResponse<TMethod extends CoreMethodName>(
  method: TMethod,
  value: unknown
): ValidationResult<CoreMethodResponse<TMethod>> {
  const schemaStem = methodSchemaStem(method);
  const responseValue =
    typeof value === "object" && value !== null
      ? (value as Record<string, unknown>)
      : null;
  const hasResult = responseValue !== null && Object.hasOwn(responseValue, "result");
  const hasError = responseValue !== null && Object.hasOwn(responseValue, "error");

  if (hasResult && !hasError) {
    return validateAgainstSchema<CoreMethodResponse<TMethod>>(
      `${METHODS_SCHEMA_ID}#/$defs/${schemaStem}SuccessResponse`,
      `${method} response`,
      value
    );
  }

  if (hasError && !hasResult) {
    return validateAgainstSchema<CoreMethodResponse<TMethod>>(
      `${METHODS_SCHEMA_ID}#/$defs/${schemaStem}ErrorResponse`,
      `${method} response`,
      value
    );
  }

  return validateAgainstSchema<CoreMethodResponse<TMethod>>(
    `${CORE_SCHEMA_ID}#/$defs/ResponseEnvelope`,
    `${method} response`,
    value
  );
}

export function parseMethodResponse<TMethod extends CoreMethodName>(
  method: TMethod,
  value: unknown
): CoreMethodResponse<TMethod> {
  const result = safeParseMethodResponse(method, value);

  if (!result.success) {
    throw result.error;
  }

  return result.data;
}

export function assertMethodResponse<TMethod extends CoreMethodName>(
  method: TMethod,
  value: unknown
): asserts value is CoreMethodResponse<TMethod> {
  parseMethodResponse(method, value);
}

export { AscpValidationError } from "./types.js";
export type * from "./types.js";
