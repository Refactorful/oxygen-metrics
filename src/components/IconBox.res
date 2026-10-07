open Chakra

@react.component
let make = (~children, ~size, ~borderRadius=12, ~bg=?, ~color=?, ~className="") => {
  let defaultBackground = Chakra.useColorModeValue("blue.700", "blue.300")
  let backgroundColor = bg->Option.getOr(defaultBackground)
  let textColor = color->Option.getOr("white")

  let boxstyle: JsxDOM.style = {
    borderRadius: Int.toString(borderRadius) ++ "px",
    height: Int.toString(size) ++ "px",
    width: Int.toString(size) ++ "px",
  }

  <Box
    className={`flex items-center justify-center flex-shrink-0 ${className}`}
    style=boxstyle
    bg=backgroundColor
    color=textColor>
    {children}
  </Box>
}
