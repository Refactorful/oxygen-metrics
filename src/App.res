open Chakra
open ReactIcons

// Components
open SideBar

module Router = {
  @react.component
  let make = () => {
    let url = RescriptReactRouter.useUrl()
    // Single-page dashboard: the app can be served from the root (vite dev),
    // from under the Oxygen docs path (/docs/metrics) or from the packaged
    // bundle path, so only the placeholder "Test" route falls through to 404
    switch url.path {
    | list{"data"} => <Text> "404" </Text>
    | _ => <Dashboard />
    }
  }
}

let routes = [
  {"path": "/", "name": "Dashboard", "icon": <IoHome size=15 />},
]

@react.component
let make = () => {
  Metrics.usePolling()

  let {isOpen, onOpen, onClose} = Chakra.useDisclosure()
  let backgroundColor = Chakra.useColorModeValue("gray.50", "gray.800")
  let navbarIcon = Chakra.useColorModeValue("gray.500", "gray.200")
  let pluginBg = Chakra.useColorModeValue("white", "gray.600")

  <HStack
    style={{
      "height": "100vh",
      "alignItems": "flex-start",
    }}
    bg=backgroundColor
    spacing="0">
    <SideBar routes />
    <Box className="h-full w-full overflow-y-auto">
      <Settings isOpen onClose />
      <Navbar brandText="Dashboard" onOpen />

      // Fixed plugin-style settings trigger (bottom right)
      <IconButton
        icon={<FiSettings size=20 />}
        \"aria-label"="Settings (fixed)"
        color=navbarIcon
        bg=pluginBg
        onClick={_ => onOpen()}
        position="fixed"
        bottom="30px"
        right="35px"
        h="52px"
        w="52px"
        borderRadius="50px"
        shadow="0 2px 12px 0 rgb(0 0 0 / 16%)"
        zIndex=100
      />

      <Router />
    </Box>
  </HStack>
}

