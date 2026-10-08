// Browser entry. Registers the callable `window.OxygenMetrics` global so a host
// page can embed the dashboard without bundling it:
//
//   window.OxygenMetrics({ endpoint: "/docs/metrics/data", domId: "oxygen-metrics" })
//   window.OxygenMetrics({ endpoint: "http://127.0.0.1:8080/docs/metrics/data" })
//   window.OxygenMetrics("oxygen-metrics")  // shorthand: first arg is the domId
//   window.OxygenMetrics.mount({ ... })     // same function
//
// `endpoint` (alias `url`) is the base URL of the metrics API and defaults to
// the path Oxygen.jl rewrites to `<docs_path>/metrics/` (see Metrics.res).
// `domId` (alias `dom_id`) is the id of an empty container element and defaults
// to `"oxygen-metrics"`. Returns `{ unmount }` so callers can tear the
// dashboard down.

%%raw("import './index.css'")
%%raw("import '@fontsource/roboto/400.css'")
%%raw("import '@fontsource/roboto/500.css'")
%%raw("import '@fontsource/roboto/700.css'")

open Chakra

// Matches the original dashboard: Roboto for body copy, the Chakra default
// system stack for headings, and the custom gray.700 from the Vision UI theme
let theme = Chakra.extendTheme({
  "fonts": {
    "body": "Roboto, sans-serif",
  },
  "colors": {
    "gray": {
      "700": "#1f2733",
    },
  },
})

let normalizeConfig: ('config, string) => {..} = %raw(`(function(config, defaultEndpoint) {
  if (typeof config === "string") {
    return { domId: config, endpoint: defaultEndpoint };
  }
  var options = config || {};
  return {
    domId: options.domId || options.dom_id || "oxygen-metrics",
    endpoint: options.endpoint || options.url || defaultEndpoint,
  };
})`)

let getElement: string => 'element = %raw(`(function(id) {
  var el = document.getElementById(id);
  if (!el) {
    throw new Error("OxygenMetrics: no element with id '" + id + "'");
  }
  return el;
})`)

let mount = (config: 'config): {..} => {
  let normalized = normalizeConfig(config, Metrics.defaultBasePath)
  let domId: string = normalized["domId"]
  let endpoint: string = normalized["endpoint"]
  let container = getElement(domId)
  let root = ReactDOM.Client.createRoot(container)
  ReactDOM.Client.Root.render(
    root,
    <ChakraProvider resetCSS={false} theme>
      <App endpoint />
    </ChakraProvider>,
  )
  {"unmount": () => ReactDOM.Client.Root.unmount(root, ())}
}

let register: (string, 'a) => unit = %raw(`(function(name, value) {
  if (typeof window !== "undefined") {
    window[name] = value;
  }
})`)

// Make the function callable as `OxygenMetrics(config)` and also expose
// `OxygenMetrics.mount(config)`, like `SwaggerUIBundle`.
let withMountAlias: 'a => {..} = %raw(`(function(fn) { fn.mount = fn; return fn; })`)

let () = register("OxygenMetrics", withMountAlias(mount))
