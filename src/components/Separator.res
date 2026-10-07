open Chakra

/**
  The gradient hairline separator used throughout the original dashboard
 */
@react.component
let make = (~mt=?, ~mb=?) => {
  let style: JsxDOM.style = {
    height: "1px",
    width: "100%",
    background: "linear-gradient(90deg, rgba(224, 225, 226, 0) 0%, #E0E1E2 49.52%, rgba(224, 225, 226, 0) 100%)",
  }

  <Box style mt=?mt mb=?mb />
}
