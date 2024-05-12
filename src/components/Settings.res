open Chakra

module Settings = {
  @react.component
  let make = () => {
    let (isOpen, setIsOpen) = React.useState(() => false)

    <Drawer isOpen={isOpen} onClose={() => setIsOpen(_ => false)}>
      <DrawerOverlay />
      <DrawerContent>
        <DrawerCloseButton />
        <DrawerHeader> {`3 drawer contents`->React.string} </DrawerHeader>
        <DrawerBody>
          <Text> "hello world" </Text>
        </DrawerBody>
      </DrawerContent>
    </Drawer>
  }
}