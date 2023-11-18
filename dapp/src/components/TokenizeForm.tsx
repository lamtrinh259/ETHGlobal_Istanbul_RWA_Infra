import { Button, Center, Spinner, Stack } from "@chakra-ui/react"
import { useAtom } from "jotai";
import { useState } from "react"
import { useWalletClient } from "wagmi";
import { stageAtom } from "../store/stage";
import { NFT_ABI, NFT_BYTES } from "../abi/nft";


export const TokenizeForm = () => {
    const [isLoading, setIsLoading] = useState(false);
    const { data: client } = useWalletClient();
    const [stage, setStage] = useAtom(stageAtom);

    return <Stack pl={2} pr={4} gap={4}>
        <Center mt={"100px"}>
            <Button
                isLoading={isLoading}
                onClick={async () => {
                    if (!client) return;

                    setIsLoading(true);
                    // const result = await client.deployContract({
                    //     args: [client.account.address,],
                    //     abi: NFT_ABI,
                    //     account: client.account,
                    //     bytecode: NFT_BYTES,
                    // });
                    // result
                    setTimeout(() => {
                        setStage(stage + 1);
                    }, 2000);
                }}>
                Tokenize
            </Button>
        </Center>
    </Stack >
}