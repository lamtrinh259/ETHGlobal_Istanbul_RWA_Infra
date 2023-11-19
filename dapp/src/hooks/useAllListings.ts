import { useEffect, useState } from "react";
import { useNetwork, usePublicClient, useWalletClient } from "wagmi";
import { Offer } from "../types";
import { parseAbiItem } from "viem";
import {
  getMarketplaceContractAddress,
  publicClientToProvider,
} from "../lib/utils";
import { ethers } from "ethers";
import marketplaceConfig from "../../../contracts/out/Marketplace.sol/Marketplace.json";

export function useAllListings() {
  const publicClient = usePublicClient();
  const { chain } = useNetwork();
  const { data: client } = useWalletClient();
  const [listings, setListings] = useState<Offer[]>([]);

  useEffect(() => {
    (async () => {
      const provider = publicClientToProvider(publicClient);
      const marketplaceContract = getMarketplaceContractAddress(chain.id)!;
      const contract = new ethers.Contract(
        marketplaceContract,
        marketplaceConfig.abi,
        provider
      );
      const filter = contract.filters.OfferCreated();
      const events = await contract.queryFilter(filter);
      const offers = events.map((event) => event.args);
      setListings(
        offers.map(
          (x) =>
            ({
              seller: x?.seller,
              tokenInfo: {
                amount: x?.tokenInfo.amount,
                fees: x?.tokenInfo.fees,
                tokenAddress: x?.tokenInfo.tokenAddress,
              },
              nftInfo: {
                nftAddress: x?.nftInfo.nftAddress,
                tokenId: x?.nftInfo.tokenId,
              },
              offerId: x?.offerId,
            } as any)
        )
      );
    })();
  }, [publicClient, client, chain]);

  return listings;
}
