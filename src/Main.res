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

switch ReactDOM.querySelector("#root") {
| Some(domElement) =>
  ReactDOM.Client.createRoot(domElement)->ReactDOM.Client.Root.render(
    <ChakraProvider resetCSS={false} theme>
      <App />
    </ChakraProvider>,
  )
| None => ()
}
