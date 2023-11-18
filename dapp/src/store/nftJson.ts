import { atom } from "jotai";

type NFTJson = {
    name: string,
    category: string
    condition: string
    description: string
    price: number
    currency: string
}
export const nftJsonAtom = atom<NFTJson>({} as any as NFTJson);
