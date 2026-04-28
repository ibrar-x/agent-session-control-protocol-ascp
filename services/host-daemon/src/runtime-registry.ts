import { createDefaultCodexHostRuntime } from "@ascp/adapter-codex";
import type { AscpHostRuntime } from "@ascp/host-service";

import type { DaemonRuntimeKind } from "./config.js";

export interface RuntimeRegistry {
  createRuntime(runtime: string): AscpHostRuntime;
}

export interface RuntimeRegistryFactories {
  codex: () => AscpHostRuntime;
}

export function createRuntimeRegistry(factories?: Partial<RuntimeRegistryFactories>): RuntimeRegistry {
  const codexFactory =
    factories?.codex ?? (() => createDefaultCodexHostRuntime());

  return {
    createRuntime(runtime: string): AscpHostRuntime {
      if (runtime === "codex") {
        return codexFactory();
      }

      throw new Error(`Unsupported daemon runtime: ${runtime}`);
    }
  };
}

export function isDaemonRuntimeKind(value: string): value is DaemonRuntimeKind {
  return value === "codex";
}
