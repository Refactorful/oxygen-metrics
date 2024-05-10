
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
    ~onClick: ReactEvent.Mouse.t => unit
  ) => React.element = "Button"
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
    ~children: React.element
  ) => React.element = "HStack"
}

module VStack = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element
  ) => React.element = "VStack"
}

module Box = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element,
    ~className: string =?,
    ~backgroundColor: string =?
  ) => React.element = "Box"
}


// Data Display Components
module Card = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element
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
    ~children: React.element
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
    ~onClick: ReactEvent.Mouse.t => unit =?
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
    ~children: string
  ) => React.element = "Heading"
}

module Highlight = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: string
  ) => React.element = "Highlight"
}