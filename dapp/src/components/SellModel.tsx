import { Text, Box, HStack, Img, Modal, ModalBody, ModalCloseButton, ModalContent, ModalHeader, ModalOverlay, Stack, Tag, TagLeftIcon, TagLabel, Divider, Input, ModalFooter, Button, Select } from "@chakra-ui/react"
import { FaTag } from "react-icons/fa"
import { NFTJson } from "../store/nftJson"
import { useState } from "react";

export const SellModel = ({ nftJson, src, isOpen, onClose }: { nftJson: NFTJson, src: string, isOpen: boolean, onClose: () => void }) => {
    const [amount, setAmount] = useState<number | undefined>(undefined);
    const price = 2;
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
                            <Text >{nftJson.name}</Text>
                            <HStack spacing={4}>
                                {[nftJson.category, nftJson.condition].map((name) => (
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
                        <HStack w={"full"} gap={4}>
                            <Box flexGrow={1}>
                                <Text mb={2}>Price</Text>
                                <Input
                                    value={amount}
                                    onChange={(e) => setAmount(Number(e.target.value))}
                                    backgroundColor={"#D8DAF6"}
                                    placeholder="Amount"></Input>
                            </Box>
                            <Box flexGrow={1}>
                                <Text mb={2}>Currency</Text>
                                <Select
                                    // onChange={(e) => setNftJson({ ...nftJson, currency: e.target.value })}
                                    backgroundColor={"#D8DAF6"}
                                    placeholder='Select option'>
                                    <option value='USDC'>USDC</option>
                                    <option value='ETH'>ETH</option>
                                </Select>
                            </Box>
                        </HStack>
                    </Box>
                    <Box>
                        <Text mb={2}>Expiry Date</Text>
                        <HStack w={"full"} gap={4}>
                            <Input
                                value={"2023-11-20"}
                                flex={1}
                                backgroundColor={"#D8DAF6"}
                                placeholder="Select a Date"></Input>
                            <Input
                                value={"12:00"}
                                flex={1}
                                backgroundColor={"#D8DAF6"}
                                placeholder="Time"></Input>
                        </HStack>
                    </Box>
                    <Divider borderColor={"#CBCCE0"} />
                    <Stack fontSize={"small"}>
                        <HStack justifyContent={"space-between"}>
                            <Text color="#8B8B93">Listing Price</Text>
                            <Text>${(price * (amount ?? 0)).toFixed(2)}</Text>
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
                            <Text>${(price * (amount ?? 0) * 0.95).toFixed(2)}</Text>
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