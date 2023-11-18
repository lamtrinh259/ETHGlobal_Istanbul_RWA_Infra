import { Box } from "@chakra-ui/react";
import dynamic from "next/dynamic";

const PushChat = dynamic(() => import('../components/PushChat'), {
    loading: () => <p>Loading...</p>,
})

const Chat = () => {
    return <Box paddingTop={"100px"} maxHeight={"300px"}>
        <PushChat />
    </Box>
}
export default Chat;