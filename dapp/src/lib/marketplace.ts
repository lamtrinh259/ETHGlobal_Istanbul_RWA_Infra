import { PublicClient, WalletClient } from "viem";
import {
  getDeployedContract,
  getMarketplaceContractAddress,
  objectToTuple,
  walletClientToSigner,
} from "./utils";
import marketplaceConfig from "../../../contracts/out/Marketplace.sol/Marketplace.json";
import shopConfig from "../../../contracts/out/Shop.sol/Shop.json";
import { NFTInfo, TokenInfo } from "../types";
import { ethers } from "ethers";

export async function listProduct(
  tokenInfo: TokenInfo,
  nftInfo: NFTInfo,
  expiresAt: number,
  chainId: number,
  client: WalletClient,
  publicClient: PublicClient
) {
  const shopContract = await getDeployedContract(
    client.account?.address!,
    chainId
  );
  const marketplaceContract = await getMarketplaceContractAddress(chainId);
  const isApprovedForAll = (await publicClient.readContract({
    address: shopContract as `0x${string}`,
    abi: shopConfig.abi,
    functionName: "isApprovedForAll",
    args: [client.account?.address!, marketplaceContract],
  } as any)) as boolean;
  if (!isApprovedForAll) {
    const approveTxHash = await client.writeContract({
      address: shopContract as `0x${string}`,
      abi: shopConfig.abi,
      functionName: "setApprovalForAll",
      args: [marketplaceContract as `0x${string}`, true],
    } as any);
    console.log("approveTxHash", approveTxHash);
  }
  const txHash = await client.writeContract({
    address: marketplaceContract as `0x${string}`,
    abi: marketplaceConfig.abi,
    functionName: "createOffer",
    args: [objectToTuple(tokenInfo), objectToTuple(nftInfo), expiresAt],
  } as any);
  console.log("txHash", txHash);
  await publicClient.waitForTransactionReceipt({
    hash: txHash,
  });
  return txHash;
}

export async function cancelListing(
  offerId: string,
  chainId: number,
  client: WalletClient,
  publicClient: PublicClient
) {
  const marketplaceContract = await getMarketplaceContractAddress(chainId);
  const txHash = await client.writeContract({
    address: marketplaceContract as `0x${string}`,
    abi: marketplaceConfig.abi,
    functionName: "cancelOffer",
    account: client.account?.address as `0x${string}`,
    args: [offerId],
  } as any);
  console.log("txHash", txHash);
  await publicClient.waitForTransactionReceipt({
    hash: txHash,
  });
  return txHash;
}

export async function buyProduct(
  offerId: string,
  chainId: number,
  client: WalletClient,
  publicClient: PublicClient
) {
  const marketplaceContract = await getMarketplaceContractAddress(chainId);
  const txHash = await client.writeContract({
    address: marketplaceContract as `0x${string}`,
    abi: marketplaceConfig.abi,
    functionName: "buy",
    account: client.account?.address as `0x${string}`,
    args: [offerId],
  } as any);
  console.log("txHash", txHash);
  await publicClient.waitForTransactionReceipt({
    hash: txHash,
  });
  return txHash;
}
