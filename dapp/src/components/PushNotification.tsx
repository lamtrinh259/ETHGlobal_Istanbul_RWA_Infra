import { useWalletClient } from "wagmi";
import { IFeeds, PushAPI } from "@pushprotocol/restapi";
import { useEffect, useRef, useState } from "react";
import { DrawerBody, DrawerFooter, Button, Drawer, DrawerCloseButton, DrawerContent, DrawerHeader, DrawerOverlay, Link, Stack, useDisclosure } from "@chakra-ui/react";

export const PushNotification = ({ account }: { account?: string }) => {
    const { data: walletClient } = useWalletClient();
    const [chats, setChats] = useState<IFeeds[]>([]);
    const [isLoading, setIsLoading] = useState(false);
    const { isOpen, onOpen, onClose } = useDisclosure()
    const btnRef = useRef(null)

    useEffect(() => {
        if (!walletClient) return;

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
    }, [walletClient])


    return (
        <>
            <Button pos={"fixed"} right={8} bottom={8} ref={btnRef} colorScheme='teal' onClick={onOpen}>
                Chats
            </Button>
            <Drawer
                isOpen={isOpen}
                placement='right'
                onClose={onClose}
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
                                    isExternal
                                    key={chat.chatId}
                                    href={`/chat?account=${chat.chatId}`}>{chat.chatId}</Link>
                            )}
                        </Stack>
                    </DrawerBody>

                    <DrawerFooter>
                        <Button variant='outline' background={"transparent"} mr={3} onClick={onClose}>
                            Cancel
                        </Button>
                    </DrawerFooter>
                </DrawerContent>
            </Drawer>
        </>

    );
}
