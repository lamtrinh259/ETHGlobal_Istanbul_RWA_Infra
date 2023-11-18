import { useWalletClient } from "wagmi";
import { IFeeds, PushAPI } from "@pushprotocol/restapi";
import { useEffect, useRef, useState } from "react";
import { Text, DrawerBody, DrawerFooter, Button, Drawer, DrawerCloseButton, DrawerContent, DrawerHeader, DrawerOverlay, Link, Stack, useDisclosure, HStack, Image, Img } from "@chakra-ui/react";
import PushChat from "./PushChat";
import { useAtom } from "jotai";
import { chatOpenAtom } from "../store/chat";

export const PushNotification = () => {
    const { data: walletClient } = useWalletClient();
    const [chats, setChats] = useState<IFeeds[]>([]);
    const [isLoading, setIsLoading] = useState(false);
    const [isOpen, setOpen] = useAtom(chatOpenAtom);
    const btnRef = useRef(null)

    useEffect(() => {
        if (!walletClient || !isOpen) return;

        async function doit() {
            setIsLoading(true);
            // @ts-ignore
            const userAlice = await PushAPI.initialize(walletClient!, { env: "prod" });
            const requests = await userAlice.chat.list("REQUESTS");
            await Promise.all(requests.map((r) => userAlice.chat.accept(r.chatId!)));
            const chats = await userAlice.chat.list("CHATS");
            setChats(chats);
            setIsLoading(false);
        }

        doit();
    }, [walletClient, isOpen])

    return (
        <>
            <Button
                bg={"white"}
                rounded={"full"}
                height={"60px"}
                width={"60px"}
                _hover={{ bg: "gray.100" }}
                zIndex={1000} pos={"fixed"} right={8} bottom={8} ref={btnRef} colorScheme='teal' onClick={() => setOpen(true)}>
                <Img src={"/chat.png"} />
            </Button>
            <Drawer
                size={"lg"}
                isOpen={isOpen}
                placement='right'
                onClose={() => setOpen(false)}
                finalFocusRef={btnRef}
            >
                <DrawerOverlay />
                <DrawerContent>
                    <DrawerCloseButton />
                    <DrawerHeader>Chats</DrawerHeader>
                    <DrawerBody>
                        {isLoading && <p>Loading...</p>}
                        <Stack>
                            {chats.map((chat) =>
                                <Link
                                    rounded={"full"}
                                    _hover={{ bg: "gray.100" }}
                                    padding={4}
                                    bg="gray.200"
                                    isExternal
                                    key={chat.chatId}
                                    href={`/chat?account=${chat.chatId}`}>
                                    <HStack>
                                        <Image src="/avatar.png" />
                                        {/* @ts-ignore */}
                                        <Text>{chat.msg.messageObj?.content}</Text>
                                    </HStack>
                                </Link>
                            )}
                        </Stack>
                        <PushChat />
                    </DrawerBody>

                    <DrawerFooter>
                        <Button variant='outline' background={"transparent"} mr={3} onClick={() => setOpen(false)}>
                            Cancel
                        </Button>
                    </DrawerFooter>
                </DrawerContent>
            </Drawer>
        </>

    );
}
