import ethers from "ethers";

export function getDeployedContract(owner: string, chainId: number) {
  const deployedContracts = JSON.parse(
    localStorage.getItem("deployedContracts") || "{}"
  );
  const ownerContracts = deployedContracts[owner];
  if (!ownerContracts) {
    return;
  }
  return ownerContracts[chainId.toString()];
}

export function saveDeployedContract(
  owner: string,
  contract: string,
  chainId: number
) {
  const deployedContracts = JSON.parse(
    localStorage.getItem("deployedContracts") || "{}"
  );
  if (!deployedContracts[owner]) {
    deployedContracts[owner] = {};
  }
  deployedContracts[owner][chainId.toString()] = contract;
  localStorage.setItem("deployedContracts", JSON.stringify(deployedContracts));
}

export function getJSONRPCProvider() {
  return new ethers.providers.JsonRpcProvider(
    process.env.NEXT_PUBLIC_JSON_RPC_URL
  );
}
