import { cp, mkdir } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const scriptDir = dirname(fileURLToPath(import.meta.url));
const packageDir = resolve(scriptDir, "..");
const sourceDir = resolve(packageDir, "src/validation/schemas");
const targetDir = resolve(packageDir, "dist/validation/schemas");

await mkdir(targetDir, { recursive: true });
await cp(sourceDir, targetDir, { recursive: true });
