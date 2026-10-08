import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

// Library build: emits an IIFE bundle exposing the global `OxygenMetricsBundle`
// (which registers the callable `window.OxygenMetrics`) plus the extracted
// stylesheet. This is the artifact a host page embeds into its own HTML.
//
// The embed ships without the bundled Roboto webfonts: Vite's library mode
// inlines every font file as base64, which would balloon styles.css from ~40 kB
// to ~900 kB. Hosts that want the exact typeface can load Roboto themselves;
// otherwise the theme falls back to sans-serif.
function stripBundledFonts() {
  return {
    name: "oxygen-metrics:strip-bundled-fonts",
    enforce: "pre",
    transform(code, id) {
      if (!id.endsWith("Main.res.mjs")) return null;
      return code.replace(/^\s*import\s+["']@fontsource\/[^"']+["'];?\s*$/gm, "");
    },
  };
}

export default defineConfig({
  plugins: [stripBundledFonts(), react({ include: ["**/*.res.mjs"] })],
  // The favicon in public/ is only used by the standalone page; don't copy it
  // into the library output.
  publicDir: false,
  define: {
    // Library mode does not replace `process.env.NODE_ENV`, which would pull
    // React's development build (and its warnings) into the bundle.
    "process.env.NODE_ENV": JSON.stringify("production"),
  },
  build: {
    outDir: "dist-lib",
    emptyOutDir: true,
    target: "es2022",
    lib: {
      entry: "src/Main.res.mjs",
      // Rollup assigns this name to the module namespace. Keep it distinct from
      // the public global so it can't overwrite the callable `window.OxygenMetrics`.
      name: "OxygenMetricsBundle",
      formats: ["iife"],
      fileName: () => "index.js",
    },
    rollupOptions: {
      output: {
        // Vite 5 names the extracted library stylesheet `style.css`; hosts
        // expect `styles.css`.
        assetFileNames: assetInfo =>
          assetInfo.name === "style.css" ? "styles.css" : "assets/[name]-[hash][extname]",
      },
    },
  },
});
