// Copies the embed bundle into the Oxygen.jl package, where it is served at
// `<docs_path>/metrics/`:
//
//   dist-lib/index.js       -> <target>/index.js
//   dist-lib/styles.css     -> <target>/styles.css
//   public/oxygen-logo.png  -> <target>/oxygen-logo.png
//
// Usage: bun run bundle [target-dir]
// The default target is ../Oxygen.jl/data/dashboard (override with the first
// argument or the OXYGEN_DASHBOARD_DIR environment variable).
import { mkdirSync, copyFileSync, existsSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const here = dirname(fileURLToPath(import.meta.url));
const projectRoot = resolve(here, "..");
const targetDir = resolve(
  process.argv[2] ??
    process.env.OXYGEN_DASHBOARD_DIR ??
    resolve(projectRoot, "..", "Oxygen.jl", "data", "dashboard"),
);

const files = [
  [resolve(projectRoot, "dist-lib", "index.js"), "index.js"],
  [resolve(projectRoot, "dist-lib", "styles.css"), "styles.css"],
  [resolve(projectRoot, "public", "oxygen-logo.png"), "oxygen-logo.png"],
];

mkdirSync(targetDir, { recursive: true });

for (const [source, name] of files) {
  if (!existsSync(source)) {
    throw new Error(`missing build artifact: ${source} (run \`bun run build:lib\` first)`);
  }
  const target = resolve(targetDir, name);
  copyFileSync(source, target);
  console.log(`copied ${source} -> ${target}`);
}
