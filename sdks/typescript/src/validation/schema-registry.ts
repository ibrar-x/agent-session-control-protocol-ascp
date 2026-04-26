import * as Ajv2020Module from "ajv/dist/2020.js";
import type { AnySchemaObject, ValidateFunction } from "ajv";
import * as addFormatsModule from "ajv-formats";
import coreSchemaJson from "./schemas/ascp-core.schema.json" with { type: "json" };
import capabilitiesSchemaJson from "./schemas/ascp-capabilities.schema.json" with { type: "json" };
import methodsSchemaJson from "./schemas/ascp-methods.schema.json" with { type: "json" };
import eventsSchemaJson from "./schemas/ascp-events.schema.json" with { type: "json" };
import errorsSchemaJson from "./schemas/ascp-errors.schema.json" with { type: "json" };

type AjvLike = {
  addSchema: (schema: AnySchemaObject) => void;
  compile: (schema: AnySchemaObject) => ValidateFunction;
};

type Ajv2020Constructor = new (options?: Record<string, unknown>) => AjvLike;
type AddFormatsPlugin = (ajv: AjvLike) => void;

const Ajv2020 = Ajv2020Module.default as unknown as Ajv2020Constructor;
const addFormats = addFormatsModule.default as unknown as AddFormatsPlugin;

const ajv = new Ajv2020({
  allErrors: true,
  strict: true,
  strictRequired: false,
  validateFormats: true
});

addFormats(ajv);

const loadedSchemas = [
  coreSchemaJson,
  capabilitiesSchemaJson,
  methodsSchemaJson,
  eventsSchemaJson,
  errorsSchemaJson
] as [
  AnySchemaObject,
  AnySchemaObject,
  AnySchemaObject,
  AnySchemaObject,
  AnySchemaObject
];

for (const schema of loadedSchemas) {
  ajv.addSchema(schema);
}

const [coreSchema, capabilitiesSchema, methodsSchema, eventsSchema, errorsSchema] =
  loadedSchemas;

const validatorCache = new Map<string, ValidateFunction>();

export const CORE_SCHEMA_ID = coreSchema.$id as string;
export const CAPABILITIES_SCHEMA_ID = capabilitiesSchema.$id as string;
export const METHODS_SCHEMA_ID = methodsSchema.$id as string;
export const EVENTS_SCHEMA_ID = eventsSchema.$id as string;
export const ERRORS_SCHEMA_ID = errorsSchema.$id as string;

export function getValidator(schemaRef: string): ValidateFunction {
  const cachedValidator = validatorCache.get(schemaRef);

  if (cachedValidator) {
    return cachedValidator;
  }

  const validator = ajv.compile({ $ref: schemaRef });

  validatorCache.set(schemaRef, validator);

  return validator;
}
