import type { BigNumberish } from "ethers";

export type TokenInfo = {
  amount: BigNumberish;
  fees: BigNumberish;
  tokenAddress: string;
};

export type NFTInfo = {
  nftAddress: string;
  tokenId: BigNumberish;
};

export type Offer = {
  seller: string;
  tokenInfo: TokenInfo;
  nftInfo: NFTInfo;
  expiresAt: BigNumberish;
};

export type Bid = {
  bidder: string;
  tokenInfo: TokenInfo;
  nftInfo: NFTInfo;
  expiresAt: BigNumberish;
};
