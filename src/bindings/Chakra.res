/**
  Hand-written bindings for the subset of Chakra UI (v2) used by the dashboard.
  Every component takes `children` and a polymorphic, optional set of props.
 */

type colorModeHook = {
  colorMode: string,
  toggleColorMode: unit => unit,
  setColorMode: string => unit,
}

type disclosureHook = {
  isOpen: bool,
  onOpen: unit => unit,
  onClose: unit => unit,
}

@module("@chakra-ui/react")
external useColorMode: unit => colorModeHook = "useColorMode"

@module("@chakra-ui/react")
external useColorModeValue: ('value, 'value) => 'value = "useColorModeValue"

@module("@chakra-ui/react")
external useDisclosure: unit => disclosureHook = "useDisclosure"

@module("@chakra-ui/react")
external extendTheme: 'theme => 'theme = "extendTheme"

module ChakraProvider = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element,
    ~resetCSS: bool=?,
    ~theme: 'theme=?,
  ) => React.element = "ChakraProvider"
}

// ---------------------------------------------------------------------------
// Buttons
// ---------------------------------------------------------------------------

module Button = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element,
    ~onClick: ReactEvent.Mouse.t => unit=?,
    ~size: string=?,
    ~variant: string=?,
    ~colorScheme: string=?,
    ~className: string=?,
    ~style: 'style=?,
    ~w: string=?,
    ~me: string=?,
    ~mb: string=?,
  ) => React.element = "Button"
}

module IconButton = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~icon: React.element,
    ~\"aria-label": string=?,
    ~onClick: ReactEvent.Mouse.t => unit=?,
    ~size: string=?,
    ~variant: string=?,
    ~colorScheme: string=?,
    ~color: string=?,
    ~bg: string=?,
    ~position: string=?,
    ~top: string=?,
    ~bottom: string=?,
    ~right: string=?,
    ~zIndex: int=?,
    ~h: string=?,
    ~w: string=?,
    ~borderRadius: string=?,
    ~shadow: string=?,
  ) => React.element = "IconButton"
}

// ---------------------------------------------------------------------------
// Layout
// ---------------------------------------------------------------------------

module Box = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element=?,
    ~className: string=?,
    ~style: 'style=?,
    ~onClick: ReactEvent.Mouse.t => unit=?,
    ~display: string=?,
    ~flexDirection: string=?,
    ~alignItems: string=?,
    ~justifyContent: string=?,
    ~gap: string=?,
    ~w: string=?,
    ~h: string=?,
    ~width: string=?,
    ~height: string=?,
    ~p: string=?,
    ~px: string=?,
    ~py: string=?,
    ~pt: string=?,
    ~ps: string=?,
    ~pe: string=?,
    ~pb: string=?,
    ~pl: string=?,
    ~pr: string=?,
    ~mt: string=?,
    ~mb: string=?,
    ~me: string=?,
    ~bg: string=?,
    ~color: string=?,
    ~borderRadius: string=?,
  ) => React.element = "Box"
}

module Flex = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element=?,
    ~className: string=?,
    ~style: 'style=?,
    ~direction: string=?,
    ~align: string=?,
    ~justify: string=?,
    ~gap: string=?,
    ~w: string=?,
    ~h: string=?,
    ~mt: string=?,
    ~mb: string=?,
  ) => React.element = "Flex"
}

module Stack = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element=?,
    ~direction: string=?,
    ~spacing: string=?,
  ) => React.element = "Stack"
}

module HStack = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element=?,
    ~className: string=?,
    ~style: 'style=?,
    ~spacing: string=?,
    ~mb: string=?,
    ~bg: string=?,
  ) => React.element = "HStack"
}

module VStack = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element=?,
    ~className: string=?,
    ~style: 'style=?,
    ~spacing: string=?,
  ) => React.element = "VStack"
}

module Grid = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element=?,
    ~templateColumns: 'columns=?,
    ~templateRows: 'rows=?,
    ~gap: string=?,
    ~my: string=?,
    ~mb: string=?,
  ) => React.element = "Grid"
}

module SimpleGrid = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element,
    ~columns: 'columns=?,
    ~spacing: string=?,
  ) => React.element = "SimpleGrid"
}

module Center = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element,
    ~className: string=?,
    ~style: 'style=?,
    ~h: string=?,
  ) => React.element = "Center"
}

module Container = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element,
    ~className: string=?,
    ~style: 'style=?,
  ) => React.element = "Container"
}

// ---------------------------------------------------------------------------
// Form controls
// ---------------------------------------------------------------------------

module Checkbox = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element,
    ~isChecked: bool=?,
    ~isDisabled: bool=?,
    ~onChange: ReactEvent.Form.t => unit=?,
  ) => React.element = "Checkbox"
}

module CheckboxGroup = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element,
  ) => React.element = "CheckboxGroup"
}

module Switch = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~isChecked: bool=?,
    ~isDisabled: bool=?,
    ~colorScheme: string=?,
    ~onChange: ReactEvent.Form.t => unit=?,
  ) => React.element = "Switch"
}

module Select = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element,
    ~value: string=?,
    ~size: string=?,
    ~w: string=?,
    ~onChange: ReactEvent.Form.t => unit=?,
  ) => React.element = "Select"
}

module FormControl = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element,
    ~display: string=?,
  ) => React.element = "FormControl"
}

module FormLabel = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element,
    ~fontSize: string=?,
    ~fontWeight: string=?,
    ~mb: string=?,
  ) => React.element = "FormLabel"
}

// ---------------------------------------------------------------------------
// Overlay Components
// ---------------------------------------------------------------------------

module Drawer = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element,
    ~placement: string=?,
    ~isOpen: bool=?,
    ~onClose: unit => unit=?,
    ~blockScrollOnMount: bool=?,
  ) => React.element = "Drawer"
}

module DrawerBody = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element,
    ~w: string=?,
    ~ps: string=?,
    ~pe: string=?,
  ) => React.element = "DrawerBody"
}

module DrawerFooter = {
  @react.component @module("@chakra-ui/react")
  external make: (~children: React.element) => React.element = "DrawerFooter"
}

module DrawerHeader = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element,
    ~pt: string=?,
    ~px: string=?,
  ) => React.element = "DrawerHeader"
}

module DrawerOverlay = {
  @react.component @module("@chakra-ui/react")
  external make: (~children: React.element=?) => React.element = "DrawerOverlay"
}

module DrawerContent = {
  @react.component @module("@chakra-ui/react")
  external make: (~children: React.element) => React.element = "DrawerContent"
}

module DrawerCloseButton = {
  @react.component @module("@chakra-ui/react")
  external make: (~children: React.element=?) => React.element = "DrawerCloseButton"
}

// ---------------------------------------------------------------------------
// Data Display Components
// ---------------------------------------------------------------------------

module Card = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element,
    ~className: string=?,
    ~style: 'style=?,
    ~p: string=?,
    ~mb: string=?,
    ~minH: string=?,
    ~bg: string=?,
    ~borderRadius: string=?,
    ~shadow: string=?,
  ) => React.element = "Card"
}

module CardHeader = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element,
    ~p: string=?,
    ~pl: string=?,
  ) => React.element = "CardHeader"
}

module CardBody = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element,
    ~style: 'style=?,
    ~p: string=?,
  ) => React.element = "CardBody"
}

module CardFooter = {
  @react.component @module("@chakra-ui/react")
  external make: (~children: React.element) => React.element = "CardFooter"
}

module Divider = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~mt: string=?,
    ~mb: string=?,
  ) => React.element = "Divider"
}

module Spinner = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~size: string=?,
    ~thickness: string=?,
    ~color: string=?,
    ~speed: string=?,
  ) => React.element = "Spinner"
}

module Link = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element,
    ~href: string=?,
    ~onClick: ReactEvent.Mouse.t => unit=?,
    ~style: 'style=?,
    ~className: string=?,
  ) => React.element = "Link"
}

// ---------------------------------------------------------------------------
// Typography Components
// ---------------------------------------------------------------------------

module Text = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: string,
    ~className: string=?,
    ~color: string=?,
    ~fontSize: string=?,
    ~fontWeight: string=?,
    ~mt: string=?,
    ~mb: string=?,
  ) => React.element = "Text"
}

module Heading = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: string,
    ~className: string=?,
    ~size: string=?,
    ~color: string=?,
    ~mb: string=?,
  ) => React.element = "Heading"
}

module Highlight = {
  @react.component @module("@chakra-ui/react")
  external make: (~children: string) => React.element = "Highlight"
}

// ---------------------------------------------------------------------------
// Stat Components
// ---------------------------------------------------------------------------

module Stat = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: React.element,
    ~me: string=?,
    ~style: 'style=?,
  ) => React.element = "Stat"
}

module StatLabel = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: string,
    ~style: 'style=?,
    ~fontSize: string=?,
    ~color: string=?,
    ~fontWeight: string=?,
    ~pb: string=?,
  ) => React.element = "StatLabel"
}

module StatNumber = {
  @react.component @module("@chakra-ui/react")
  external make: (
    ~children: string,
    ~style: 'style=?,
    ~fontSize: string=?,
    ~color: string=?,
  ) => React.element = "StatNumber"
}
