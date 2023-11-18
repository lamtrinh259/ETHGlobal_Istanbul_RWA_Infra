import { Button, Center, Spinner, Stack } from "@chakra-ui/react";
import { useAtom } from "jotai";
import { useState } from "react";
import { useWalletClient } from "wagmi";
import { stageAtom } from "../store/stage";
import marketplaceConfig from "../../../contracts/out/Marketplace.sol/Marketplace.json";

export const TokenizeForm = () => {
    const [isLoading, setIsLoading] = useState(false);
    const { data: client } = useWalletClient();
    const [stage, setStage] = useAtom(stageAtom);

    return (
        <Stack pl={2} pr={4} gap={4}>
            <Center mt={"100px"}>
                <Button
                    isLoading={isLoading}
                    onClick={async () => {
                        if (!client) return;

                        setIsLoading(true);
                        const address = await client.deployContract({
                            args: [client.account.address],
                            abi: marketplaceConfig.abi,
                            account: client.account,
                            // @ts-ignore
                            bytecode: marketplaceConfig.bytecode.object,
                        });
                        setTimeout(() => {
                            setStage(stage + 1);
                        }, 2000);
                    }}
                >
                    Tokenize
                </Button>
            </Center>
        </Stack>
    );
};
