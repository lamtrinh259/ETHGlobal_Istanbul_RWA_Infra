import { NextApiRequest, NextApiResponse } from "next";
import { ipfsConvert } from "../../Reusables/ipfsConvert";
import { request } from "../../Reusables/request";

export default async function handler(
    req: NextApiRequest,
    res: NextApiResponse,
) {
    const cid = req.query.cid as string;
    const img = (await request<{ data: string }>(ipfsConvert(cid)));
    return res.status(200).json(img);
}