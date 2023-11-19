import { NextApiRequest, NextApiResponse } from "next";
import { ipfsConvert } from "../../Reusables/ipfsConvert";
import { request } from "../../Reusables/request";

export default async function handler(
    req: NextApiRequest,
    res: NextApiResponse,
) {
    const cid = req.query.cid as string;
    const img = await fetch(ipfsConvert(cid));
    res.setHeader('Content-Type', 'image/png');
    res.setHeader('Content-Length', img.length);
    res.setHeader('Cache-Control', 'public, max-age=604800, immutable');
    res.send(await img.blob());
    return res;
}