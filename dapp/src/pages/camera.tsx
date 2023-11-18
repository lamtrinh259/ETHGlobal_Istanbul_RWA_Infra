import { Center } from "@chakra-ui/react";

const Camera = () => {
    return <Center h={"100vh"} w={"full"}>
        <input type="file" accept="image/*" capture="user" />
    </Center>
}

export default Camera;