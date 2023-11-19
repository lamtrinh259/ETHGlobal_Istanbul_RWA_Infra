import { Text, Box, Img, Stack, HStack, Tag, TagLeftIcon, TagLabel, Divider, Button, useDisclosure, Modal, ModalOverlay, ModalContent, ModalHeader, ModalCloseButton, ModalBody, ModalFooter, Input } from "@chakra-ui/react"
import { useRouter } from "next/router"
import { FaTag } from "react-icons/fa"
import { IoDiamondOutline } from "react-icons/io5"
import { SellModel } from "./SellModel"
import { useNFTJson } from "../hooks/useNFTJson"
import { useEffect, useState } from "react"
import { request } from "../Reusables/request"

export const ItemCard = ({ metadata, isMarket = false }: { isMarket?: boolean, metadata?: string }) => {
    let { data: nftJson } = useNFTJson(metadata);
    if (!nftJson) nftJson = {
        name: "Martha Jackson’s Mens Silver Bracelet",
        category: "Jewellery",
        condition: "Acceptable",
        description: "",
        price: 785.3,
        currency: "USDC",
        image: "/example-item.png"
    }
    const [imgSrc, setImg] = useState("/example-item.png")
    useEffect(() => {
        if (!nftJson || !nftJson.image.includes("ipfs")) return;
        request<{ data: string }>(`/api/get-ipfs-image?cid=` + nftJson.image).then(data => {
            setImg(data.data)
        })
    }, [setImg, nftJson.image])

    const { isOpen, onOpen, onClose } = useDisclosure()
    const router = useRouter();

    return <Stack
        shadow={"lg"}
        cursor={"pointer"}
        onClick={() => {
            isMarket ?
                router.push("/product/1?market=true") :
                router.push("/product/1")
        }}
        h="400px"
        w="276px"
        overflow={"hidden"}
        background={"#E7E8FF"}
        borderRadius={"10px"}
        pos={"relative"}
    >
        <Stack
            p={"12px"}
            pb={0}
            gap={2}
        >
            <Box w={"full"} h="196.941px">
                <Img
                    rounded={"10px"}
                    objectFit={"cover"}
                    src={imgSrc} w={"full"} h={"full"} />
            </Box>
            <Text >{nftJson.name}</Text>

            <HStack spacing={4}>
                {[nftJson.category, nftJson.condition].map((name) => (
                    <Tag background={"transparent"} key={name} variant='subtle' colorScheme='gray' border={"1px solid black"}>
                        <TagLeftIcon boxSize='12px' as={FaTag} />
                        <TagLabel>{name}</TagLabel>
                    </Tag>
                ))}
            </HStack>

            <Divider borderColor={"#CBCCE0"} />

            <HStack fontWeight={"bold"} fontSize="22px">
                <IoDiamondOutline width={"full"} height={"full"} />
                <Text>${nftJson.price}</Text>
            </HStack>
        </Stack>
        {isMarket ?
            <Button rounded={0} h={"45px"} pos={"absolute"} bottom={0} w={"full"}>
                Buy Asset
            </Button> :
            <Button onClick={(e) => {
                e.stopPropagation();
                onOpen();
            }} rounded={0} h={"45px"} pos={"absolute"} bottom={0} w={"full"}>
                List for Sale
            </Button>
        }

        <SellModel isOpen={isOpen} onClose={onClose} src={imgSrc} />
    </Stack>

}