import { NextApiRequest, NextApiResponse } from "next";
import { pinata } from "../../Reusables/pinata_sdk";

export default async function handler(
    req: NextApiRequest,
    res: NextApiResponse,
) {

    var fs = require('fs')
    var Readable = require('stream').Readable
    const imgBuffer = Buffer.from(req.body, 'base64')
    var s = new Readable()
    s.push(imgBuffer)
    s.push(null)

    if (req.method === "POST") {
        return res.status(200).json(
            await pinata.pinFileToIPFS(s, {
                pinataMetadata: {
                    name: "image.png",
                },
            })
        );
    }
    else {
        return res.status(400);
    }
}