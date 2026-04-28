import { describe, expect, it, vi } from "vitest";

import { createRuntimeRegistry } from "../src/runtime-registry.js";

describe("createRuntimeRegistry", () => {
  it("creates the codex runtime through the registered factory", () => {
    const codexRuntime = {
      capabilitiesGet: vi.fn(),
      hostsGet: vi.fn()
    };
    const codexFactory = vi.fn(() => codexRuntime);
    const registry = createRuntimeRegistry({
      codex: codexFactory
    });

    expect(registry.createRuntime("codex")).toBe(codexRuntime);
    expect(codexFactory).toHaveBeenCalledTimes(1);
  });

  it("fails fast when the runtime key is unsupported", () => {
    const registry = createRuntimeRegistry({
      codex: () => ({
        capabilitiesGet: vi.fn(),
        hostsGet: vi.fn()
      })
    });

    expect(() => registry.createRuntime("claude")).toThrow("Unsupported daemon runtime: claude");
  });
});
