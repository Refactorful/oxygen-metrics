open Chakra
open ReactIcons

/**
  The navigation bar from the original dashboard: a rounded rail with a
  "Pages / <brand>" breadcrumb, the page title and the settings trigger. It
  sits in the normal page flow (static) so it scrolls away with the content
 */
@react.component
let make = (~brandText, ~onOpen) => {
  let mainText = Chakra.useColorModeValue("gray.700", "gray.200")
  let secondaryText = Chakra.useColorModeValue("gray.400", "gray.200")
  let navbarIcon = Chakra.useColorModeValue("gray.500", "gray.200")

  let navbarStyle: JsxDOM.style = {
    minHeight: "75px",
    borderRadius: "16px",
    border: "1px solid transparent",
    padding: "8px 30px",
    display: "flex",
    alignItems: "center",
  }

  <Box style=navbarStyle>
    <Box>
      <HStack spacing="2">
        <Text color=secondaryText> "Pages" </Text>
        <Text color=mainText> "/" </Text>
        <Text color=mainText> {brandText} </Text>
      </HStack>
      <Text color=mainText fontWeight="bold" mt="1"> {brandText} </Text>
    </Box>
    <Box className="ml-auto" me="26px">
      <IconButton
        icon={<FiSettings size=18 />}
        \"aria-label"="Settings"
        variant="ghost"
        size="sm"
        color=navbarIcon
        onClick={_ => onOpen()}
      />
    </Box>
  </Box>
}
