import { Text, Box, HStack, Img, Modal, ModalBody, ModalCloseButton, ModalContent, ModalHeader, ModalOverlay, Stack, Tag, TagLeftIcon, TagLabel, Divider, Input, ModalFooter, Button } from "@chakra-ui/react"
import { FaTag } from "react-icons/fa"

export const SellModel = ({ src, isOpen, onClose }: { src: string, isOpen: boolean, onClose: () => void }) => {
    return <Modal isOpen={isOpen} onClose={onClose}>
        <ModalOverlay />
        <ModalContent bg="#E7E8FF">
            <ModalHeader>Create Listing</ModalHeader>
            <ModalCloseButton />
            <ModalBody>
                <Stack gap={4}>
                    <HStack>
                        <Box w="102.17px" h="78.753px;">
                            <Img
                                rounded={"10px"}
                                objectFit={"cover"}
                                src={src} w={"full"} h={"full"} />
                        </Box>
                        <Stack>
                            <Text >Martha Jackson’s Mens Silver Bracelet</Text>
                            <HStack spacing={4}>
                                {['Jewellery', 'Acceptable'].map((name) => (
                                    <Tag key={name} background={"transparent"} border={"1px solid black"}>
                                        <TagLeftIcon boxSize='12px' as={FaTag} />
                                        <TagLabel>{name}</TagLabel>
                                    </Tag>
                                ))}
                            </HStack>
                        </Stack>
                    </HStack>
                    <Divider borderColor={"#CBCCE0"} />
                    <Box>
                        <Text mb={2}>Set a Price</Text>
                        <Input
                            backgroundColor={"#D8DAF6"}
                            placeholder="Amount"></Input>
                    </Box>
                    <Box>
                        <Text mb={2}>Expiry Date</Text>
                        <HStack w={"full"} gap={4}>
                            <Input
                                flex={1}
                                backgroundColor={"#D8DAF6"}
                                placeholder="Select a Date"></Input>
                            <Input
                                flex={1}
                                backgroundColor={"#D8DAF6"}
                                placeholder="Time"></Input>
                        </HStack>
                    </Box>
                    <Divider borderColor={"#CBCCE0"} />
                    <Stack fontSize={"small"}>
                        <HStack justifyContent={"space-between"}>
                            <Text color="#8B8B93">Listing Price</Text>
                            <Text>200 USDC</Text>
                        </HStack>
                        <HStack justifyContent={"space-between"}>
                            <Text color="#8B8B93">AssetFuse Fees</Text>
                            <Text>5%</Text>
                        </HStack>
                    </Stack>
                    <Divider borderColor={"#CBCCE0"} />
                    <Stack fontSize={"small"}>
                        <HStack justifyContent={"space-between"}>
                            <Text color="#8B8B93">Total Potential Earnings</Text>
                            <Text>173 USDC</Text>
                        </HStack>
                        <HStack justifyContent={"space-between"}>
                            <Text color="#8B8B93"></Text>
                            <Text color="#8B8B93">~ $172.89</Text>
                        </HStack>
                    </Stack>
                </Stack>
            </ModalBody>

            <ModalFooter>
                <Button w={"full"} mr={3} onClick={onClose}>
                    Complete Listing
                </Button>
            </ModalFooter>
        </ModalContent>
    </Modal>
}