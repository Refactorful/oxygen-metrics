import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

// The dashboard is bundled with Oxygen.jl. When the built files are served, the
// server rewrites every occurrence of this path to `<docs_path>/metrics/`, so
// both the assets and the API requests end up under the metrics docs route.
// During `vite dev` the API path is proxied to the local Oxygen server.
const OXYGEN_PATH = "/df9a0d86-3283-4920-82dc-4555fc0d1d8b";
const OXYGEN_API_PATH = `${OXYGEN_PATH}/data`;

const proxy = {
  [OXYGEN_API_PATH]: {
    target: "http://127.0.0.1:8080",
    rewrite: path => path.replace(OXYGEN_PATH, "/docs/metrics"),
  },
};

// https://vitejs.dev/config/
export default defineConfig(({ command }) => ({
  base: command === "build" ? `${OXYGEN_PATH}/` : "/",
  plugins: [
    react({
      include: ["**/*.res.mjs"],
    }),
  ],
  server: { proxy },
  preview: { proxy },
}));
