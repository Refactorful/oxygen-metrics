%%raw("import oxygenLogo from '../assets/oxygen-logo.png'")

@val external oxygenLogo: string = "oxygenLogo"

open Chakra

let logoStyle: JsxDOM.style = {
  marginRight: "20px",
  flexShrink: "0",
}

@react.component
let make = (~routes) => {
  let (selectedIndex, setSelectedIndex) = React.useState(() => 0)

  // Matches the original sidebar: a transparent rail with a white "pill" for
  // the active route and blue icon boxes
  let brandColor = Chakra.useColorModeValue("gray.700", "white")
  let activeBg = Chakra.useColorModeValue("white", "gray.700")
  let activeTextColor = Chakra.useColorModeValue("gray.700", "white")
  let inactiveTextColor = Chakra.useColorModeValue("gray.400", "gray.400")
  let activeIconBg = Chakra.useColorModeValue("blue.700", "blue.700")
  let inactiveIconBg = Chakra.useColorModeValue("white", "gray.700")
  let inactiveIconColor = Chakra.useColorModeValue("blue.700", "blue.700")

  let itemStyle: JsxDOM.style = {
    borderRadius: "15px",
    paddingTop: "12px",
    paddingBottom: "12px",
    paddingLeft: "16px",
    marginBottom: "12px",
    width: "100%",
  }

  <VStack
    className="h-full"
    spacing="0"
    style={{
      "width": "260px",
      "minWidth": "260px",
      "height": "calc(100vh - 32px)",
      "margin": "16px 0px 16px 16px",
    }}>
    <Box className="w-full" pt="25px" mb="12px" ps="20px" pe="20px">
      <HStack className="justify-center items-center" spacing="0" mb="30px">
        <img src=oxygenLogo width="48" height="48" style=logoStyle />
        <Text fontSize="sm" fontWeight="bold" color=brandColor> "Oxygen Metrics" </Text>
      </HStack>
      <Separator />
    </Box>
    <Box className="flex-1 w-full overflow-y-auto" ps="20px" pe="20px">
      {routes
      ->Belt.Array.mapWithIndex((index, route) => {
        let isActive = selectedIndex == index

        <Box
          key={Int.toString(index)}
          className="w-full cursor-pointer flex items-center"
          style=itemStyle
          bg={isActive ? activeBg : "transparent"}
          onClick={_ => {
            RescriptReactRouter.push(route["path"])
            setSelectedIndex(_ => index)
          }}>
          <IconBox
            size=30
            borderRadius=8
            bg={isActive ? activeIconBg : inactiveIconBg}
            color={isActive ? "white" : inactiveIconColor}
            className="mr-3">
            {route["icon"]}
          </IconBox>
          <Text fontSize="sm" color={isActive ? activeTextColor : inactiveTextColor}>
            {route["name"]}
          </Text>
        </Box>
      })
      ->React.array}
    </Box>
  </VStack>
}
