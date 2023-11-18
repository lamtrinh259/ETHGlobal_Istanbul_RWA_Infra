import { Text, Box, Img, Stack, HStack, Tag, TagLeftIcon, TagLabel, Divider, Button } from "@chakra-ui/react"
import { FaTag } from "react-icons/fa"
import { IoDiamondOutline } from "react-icons/io5"

export const ItemCard = () => {
    return <Stack
        h="427px"
        w="276px"
        overflow={"hidden"}
        borderRadius={"10px"}
    >
        <Stack
            p={"12px"}
            pb={0}
            background={"#E7E8FF"}
            gap={2}
        >
            <Box w={"full"} h="196.941px">
                <Img
                    rounded={"10px"}
                    objectFit={"cover"}
                    src="./example-item.png" w={"full"} h={"full"} />
            </Box>
            <Text >Martha Jackson’s Mens Silver Bracelet</Text>

            <HStack spacing={4}>
                {['Jewellery', 'Acceptable'].map((name) => (
                    <Tag key={name} variant='subtle' colorScheme='gray' border={"1px solid black"}>
                        <TagLeftIcon boxSize='12px' as={FaTag} />
                        <TagLabel>{name}</TagLabel>
                    </Tag>
                ))}
            </HStack>

            <Divider borderColor={"#CBCCE0"} />

            <HStack fontWeight={"bold"} fontSize="22px">
                <IoDiamondOutline width={"full"} height={"full"} />
                <Text>$785.3</Text>
            </HStack>
        </Stack>
        <Button rounded={0} h={"50px"}>
            List for Sale
        </Button>
    </Stack>

}