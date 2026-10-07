open Chakra
open IconBox

@react.component
let make = (~title, ~value: string, ~icon) => {
  let cardBg = Chakra.useColorModeValue("white", "gray.700")
  let textColor = Chakra.useColorModeValue("gray.700", "white")

  <Card
    minH="83px"
    bg=cardBg
    borderRadius="15px"
    shadow="0px 3.5px 5.5px rgba(0, 0, 0, 0.02)"
    p="22px">
    <CardBody p="0">
      <Flex align="center" justify="center" w="100%">
        <Stat me="auto">
          <StatLabel fontSize="sm" color="gray.400" fontWeight="bold" pb="0.1rem"> {title} </StatLabel>
          <StatNumber fontSize="lg" color=textColor> {value} </StatNumber>
        </Stat>
        <IconBox size=45> {icon} </IconBox>
      </Flex>
    </CardBody>
  </Card>
}
