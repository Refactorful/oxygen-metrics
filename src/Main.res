%%raw("import './index.css'")

open Chakra

switch ReactDOM.querySelector("#root") {
  | Some(domElement) =>
    ReactDOM.Client.createRoot(domElement)->ReactDOM.Client.Root.render(
      <React.StrictMode>
          <ChakraProvider>
            <App />
          </ChakraProvider>
      </React.StrictMode>,
    )
  | None => ()
}
