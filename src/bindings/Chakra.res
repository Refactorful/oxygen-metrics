
module ChakraProvider = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element
  ) => React.element = "ChakraProvider"
}

module Button = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element, 
    ~onClick: ReactEvent.Mouse.t => unit,
    ~className: string =?,
  ) => React.element = "Button"
}


module Center = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element, 
    ~className: string =?,
    ~style: JsxDOM.style =?
  ) => React.element = "Center"
}

module Container = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element, 
    ~className: string =?,
    ~style: JsxDOM.style =?
  ) => React.element = "Container"
}

module Checkbox = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element,
    ~isDisabled: bool =?,
    ~onChange: ReactEvent.Form.t => unit =?
    ) => React.element = "Checkbox"
}

module CheckboxGroup = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element
  ) => React.element = "CheckboxGroup"
}


// Overlay Components

module Drawer = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element,
    ~placement: string =?,
    ~isOpen: bool =?,
    ~onClose: unit => unit = ?
  ) => React.element = "Drawer"
}

module DrawerBody = {
  @react.component @module("@chakra-ui/react")
  external make: (~children: React.element) => React.element = "DrawerBody"
}

module DrawerFooter = {
  @react.component @module("@chakra-ui/react")
  external make: (~children: React.element) => React.element = "DrawerFooter"
}

module DrawerHeader = {
  @react.component @module("@chakra-ui/react")
  external make: (~children: React.element) => React.element = "DrawerHeader"
}

module DrawerOverlay = {
  @react.component @module("@chakra-ui/react")
  external make: (~children: React.element =?) => React.element = "DrawerOverlay"
}

module DrawerContent = {
  @react.component @module("@chakra-ui/react")
  external make: (~children: React.element) => React.element = "DrawerContent"
}

module DrawerCloseButton = {
  @react.component @module("@chakra-ui/react")
  external make: (~children: React.element =?) => React.element = "DrawerCloseButton"
}

// Layout Components

module Stack = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element
  ) => React.element = "Stack"
}

module HStack = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element,
    ~className: string =?,
    ~style: JsxDOM.style =?
  ) => React.element = "HStack"
}

module VStack = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element,
    ~className: string =?,
    ~style: JsxDOM.style =?
  ) => React.element = "VStack"
}

module Box = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element,
    ~className: string =?,
    ~style: JsxDOM.style =?,
    ~onClick: ReactEvent.Mouse.t => unit =?,
    ~display: string =?,
    ~alignItems: string =?,
    ~justifyContent: string =?
  ) => React.element = "Box"
}


// Data Display Components
module Card = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element,
    ~className: string =?,
    ~style: JsxDOM.style =?
  ) => React.element = "Card"
}

module CardHeader = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element
  ) => React.element = "CardHeader"
}

module CardBody = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element,
    ~style: JsxDOM.style =?
  ) => React.element = "CardBody"
}

module CardFooter = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element
  ) => React.element = "CardFooter"
}

module Link = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element,
    ~href: string =?,
    ~onClick: ReactEvent.Mouse.t => unit =?,
    ~style: JsxDOM.style =?,
    ~className: string =?
  ) => React.element = "Link"
}



// Typography Components

module Text = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: string,
    ~className: string=?,

  ) => React.element = "Text"
}

module Heading = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: string,
    ~size: string=?
  ) => React.element = "Heading"
}

module Highlight = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: string
  ) => React.element = "Highlight"
}


module SimpleGrid = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element,
    ~columns: 'a =?,
    ~spacing: string =?,
  ) => React.element = "SimpleGrid"
}


module Stat = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element,
    ~me: string =?,
    ~style: JsxDOM.style =?
  ) => React.element = "Stat"
}


module StatLabel = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: string,
    ~style: JsxDOM.style =?
  ) => React.element = "StatLabel"
}

module StatNumber = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: string,
    ~style: JsxDOM.style =?
  ) => React.element = "StatNumber"
}