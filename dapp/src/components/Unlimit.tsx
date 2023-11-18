import { useEffect, useRef, useState } from "react";
import { GateFiDisplayModeEnum, GateFiSDK } from '@gatefi/js-sdk'
import { Box, Button } from "@chakra-ui/react";

export const Unlimit = () => {
    const embedInstanceSDK = useRef<GateFiSDK | null>(null);
    const [showIframe, setShowIframe] = useState(false) // state to control iframe visibility

    useEffect(() => {
        return () => {
            embedInstanceSDK.current?.destroy();
            embedInstanceSDK.current = null;
        };
    }, []);
    // Function to create a new embed SDK instance
    const createEmbedSdkInstance = () => {
        const randomString = require('crypto').randomBytes(32).toString('hex');
        if (typeof document !== 'undefined') {
            embedInstanceSDK.current = new GateFiSDK({
                merchantId: "9e34f479-b43a-4372-8bdf-90689e16cd5b",
                displayMode: GateFiDisplayModeEnum.Embedded,
                nodeSelector: "#embed-button",
                isSandbox: true,
                walletAddress: "0xb43Ae6CC2060e31790d5A7FDAAea828681a9bB4B",
                externalId: randomString,
                defaultFiat: {
                    currency: "USD",
                    amount: "30",
                },
                defaultCrypto: {
                    currency: "ETH"
                },
            })
        }

    }

    const handleOnClickEmbed = () => {
        if (showIframe) {
            embedInstanceSDK.current?.hide();
            setShowIframe(false);
        } else {
            if (!embedInstanceSDK.current) {
                createEmbedSdkInstance();
            }
            embedInstanceSDK.current?.show();
            setShowIframe(true);
        }
    };
    return <Box>
        <Box id="embed-button" pos={"fixed"} top={"20vh"} left={"30vw"} />
        <Button onClick={handleOnClickEmbed}>
            GateFi
        </Button>
    </Box>
}