import { Button, Center, Stack } from "@chakra-ui/react";
import { useState } from "react";
import { request } from "../Reusables/request";

const Camera = () => {
    const [imgData, setImgData] = useState<string | null>(null);
    const [isSending, setIsSending] = useState(false);
    return <Center h={"100vh"} w={"full"}>
        <Stack>
            <input type="file" accept="image/*" onChange={(event) => {
                const file = event.target.files![0];
                const reader = new FileReader();

                reader.onload = function (e) {
                    const imageData = e.target!.result;
                    imageData && setImgData(imageData.toString());
                    console.log(imageData);
                };

                reader.readAsDataURL(file);
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