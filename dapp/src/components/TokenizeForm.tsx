import { Button, Center, Spinner, Stack } from "@chakra-ui/react";
import { useAtom } from "jotai";
import { useEffect, useState } from "react";
import {
  useAccount,
  useNetwork,
  usePublicClient,
  useWalletClient,
} from "wagmi";
import { stageAtom } from "../store/stage";
import shopConfig from "../../../contracts/out/Shop.sol/Shop.json";
import { getDeployedContract, saveDeployedContract } from "../lib/utils";
import { getContractAddress } from "viem";
import { useCurrentContract } from "../hooks/useCurrentContract";

export const TokenizeForm = () => {
  const [isLoading, setIsLoading] = useState(false);
  const { data: client } = useWalletClient();
  const [stage, setStage] = useAtom(stageAtom);
  const publicClient = usePublicClient();
  const { address } = useAccount();
  const { chain } = useNetwork();
  const contractAddress = useCurrentContract();

  const getOrDeployContract = async () => {
    if (!contractAddress) {
      const txHash = await client.deployContract({
        args: [client.account.address],
        abi: shopConfig.abi,
        account: client.account,
        // @ts-ignore
        bytecode: shopConfig.bytecode.object,
      });
      // Get the contract address from the transaction
      const transaction = await publicClient.getTransaction({
        hash: txHash,
      });
      let deployedContractAddress = getContractAddress({
        from: transaction.from,
        nonce: transaction.nonce,
      });
      saveDeployedContract(address, deployedContractAddress, chain.id);
      return deployedContractAddress;
    }
    return contractAddress;
  };

  const mintNFT = async (contract: string) => {
    const txHash = await client.writeContract({
      address: contract,
      abi: shopConfig.abi,
      functionName: "mint",
      account: address,
      args: [address, ""],
    });
    console.log(txHash);
    return txHash;
  };

  return (
    <Stack pl={2} pr={4} gap={4}>
      <Center mt={"100px"}>
        <Button
          isLoading={isLoading}
          onClick={async () => {
            if (!client) {
              return;
            }
            setIsLoading(true);
            const contractAddress = await getOrDeployContract();
            await mintNFT(contractAddress);
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
