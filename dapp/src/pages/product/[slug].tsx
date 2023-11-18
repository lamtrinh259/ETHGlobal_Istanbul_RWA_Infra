import { Text, Grid, Box, Center, Tabs, TabList, Tab, TabPanels, TabPanel, Button, Stack, HStack, Tag, TagLeftIcon, TagLabel } from "@chakra-ui/react"
import { useAtom } from "jotai";
import { useRouter } from "next/router";
import { uploadedImgAtom } from "../../store/uploaded";
import Link from "next/link";
import { ArrowBackIcon } from "@chakra-ui/icons";
import { FaTag } from "react-icons/fa";
import { IoDiamondOutline } from "react-icons/io5";

const Product = () => {
    const [uploadedImg, seUploadedImg] = useAtom(uploadedImgAtom);
    return <Grid w={"100vw"} h="100vh" templateColumns='repeat(2, 1fr)' gap={0}>
        <Box
            backgroundImage={uploadedImg}
            backgroundSize={"contain"}
            backgroundPosition={"center"}
        />
        <Box w={"full"} h={"full"} pos="relative" backgroundColor={"#E7E8FF"}>
            <Stack mt={"100px"} p={8} gap={4}>
                <Link href="/assets">
                    <Text cursor="pointer" _hover={{ textDecoration: "underline" }}><ArrowBackIcon mr={2} />YOUR ASSETS</Text>
                </Link>
                <Text fontSize={"35px"}>Martha Jackson’s Mens Silver Bracelet</Text>

                <HStack spacing={4}>
                    {['Jewellery', 'Acceptable'].map((name) => (
                        <Tag background={"transparent"} key={name} variant='subtle' colorScheme='gray' border={"1px solid black"}>
                            <TagLeftIcon boxSize='12px' as={FaTag} />
                            <TagLabel>{name}</TagLabel>
                        </Tag>
                    ))}
                </HStack>

                <HStack fontWeight={"bold"} fontSize="35px" >
                    <IoDiamondOutline width={"full"} height={"full"} />
                    <Text>$785.3</Text>
                </HStack>

                <Box>
                    <Text mb={2} fontWeight={"bold"}>Description</Text>
                    <Text >This exquisite piece radiates brilliance with its immaculate facets, ensuring a mesmerizing sparkle that captivates every gaze. Set in a refined platinum band, this ring is a symbol of enduring love and sophistication. Elevate your moments with this statement piece, a celebration of exceptional craftsmanship and the pure beauty of a flawless diamond</Text>
                </Box>

                <Box>
                    <Text mb={2} fontWeight={"bold"}>Owned by</Text>
                    <Text p={"9px"}
                        borderRadius={"9px"}
                        bg={"rgba(0, 8, 79, 0.05)"}
                        w={"fit-content"}
                    >exwhyzee.eth</Text>
                </Box>
            </Stack>

            <Center mt="32">

            </Center>
            {/* <Box w={"full"} pos={"absolute"} bottom={0} p={8} borderTop={"1px solid #CBCCE0"}>
                {stage !== Stage.confirm && <Button onClick={() => {
                    setStage(stage + 1)
                }}>Proceed</Button>}
                {stage === Stage.confirm && <Button
                    onClick={() => {
                        setStage(stage + 1)
                        router.push("/assets")
                    }}>See your Assets</Button>}
            </Box> */}
        </Box>

    </Grid >
}

export default Product;