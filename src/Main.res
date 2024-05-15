%%raw("import './index.css'")

open Chakra

let client = ReactQuery.Provider.createClient()

switch ReactDOM.querySelector("#root") {
  | Some(domElement) =>
    ReactDOM.Client.createRoot(domElement)->ReactDOM.Client.Root.render(
      <React.StrictMode>
          <ChakraProvider>
            <ReactQuery.Provider client>
              <App />
              <ReactQuery.DevTools initialIsOpen={false}/>
            </ReactQuery.Provider>
          </ChakraProvider>
      </React.StrictMode>,
    )
  | None => ()
}
