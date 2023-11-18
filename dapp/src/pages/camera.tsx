import { Button, Center, Stack } from "@chakra-ui/react";
import { useState } from "react";
import { request } from "../Reusables/request";
import imageCompression from 'browser-image-compression';

const Camera = () => {
    const [imgData, setImgData] = useState<string | null>(null);
    const [isSending, setIsSending] = useState(false);
    return <Center h={"100vh"} w={"full"}>
        <Stack>
            <input type="file" accept="image/*" onChange={async (event) => {
                const file = event.target.files![0];

                const options = {
                    maxSizeMB: 0.5,
                    maxWidthOrHeight: 1920,
                    useWebWorker: true,
                }
                const compressedFile = await imageCompression(file, options);

                const reader = new FileReader();

                reader.onload = function (e) {
                    const imageData = e.target!.result;
                    imageData && setImgData(imageData.toString());
                };

                reader.readAsDataURL(compressedFile);
            }} />
            <Button isDisabled={!imgData} isLoading={isSending} onClick={async () => {
                if (!imgData) return;
                setIsSending(true);
                await request("api/upload-image",
                    "POST",
                    {},
                    imgData
                );
                setIsSending(false);
            }}>Submit</Button>
        </Stack>

    </Center >
}

export default Camera;