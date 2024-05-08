
module ChakraProvider = {
  @react.component @module("@chakra-ui/react")
  external make: (~children: React.element) => React.element = "ChakraProvider"
}


module Button = {
  @react.component @module("@chakra-ui/react")
  external make: (~children: React.element, ~onClick: ReactEvent.Mouse.t => unit) => React.element = "Button"
}
