# Cross Chain NFT Contracts

A set of connected NFT smart contracts that can be deployed on several chains and be safely minted and bridged without the danger of `tokenId` overlapping.

## Installing

Run in the terminal

```shell
git clone https://github.com/XP-NETWORK/cross-chain-nft.git
cd cross-chain-nft/
yarn
```

## Using the contract

#### 1. Flatten the contract

Run in the terminal:

```shell
npx hardhat flatten ./contracts/CrossChainNFT.sol > ./contracts/CrossChainNFT_flat.sol
```

#### 2. Hide the split contracts

Delete or comment out the old contracts, especially `CrossChainNft.sol`.

#### 3. Populate `.env`

1. rename `.env.example` to `.env`

```shell
mv .env.example .env
```

2. Populate the variables to avoid errors during the compilation & deployment stages. If you already have the private key you only need to populate the SK= field. If this field is not populated, the `hardhat.config.ts` won't work correctly.

```shell
# Private Key of the deployer
SK=
# Deployer mnemonics Example="test test test"
MNEMONICS=
```

3. If you only have mnemonics, populate the MNEMONICS= according to the example. Then run in the terminal:

```shell
ts-node ./scripts/mnem_to_sk.ts
```
As a result, you will get your private key and the address. Compare the address with the one you see in the wallet. If they match, you've correctly generated the private key to populate the SK= filed.

#### 4. Compile

Run in the terminal

```shell
npx hardhat compile
```

#### 5. Populate the environment variables

```shell
# ###########################################
#       Contract deployment Parameters      #
# ###########################################

# The name of the collection
NAME=
# A 4-6 character long identifier
SYMBOL=
# The bridge address of the current chain
# Index                        staging                                         production
# 0. aurora:                                                   0x32E8854DC2a5Fd7049DCF10ef2cb5f01300c7B47
# 1. bsc:     0x7Eac6825A851d79ae24301eA497AD8db2a0F4976       0x0B7ED039DFF2b91Eb4746830EaDAE6A0436fC4CB
# 2. moonbeam:0xce50496C6616F4688d5775966E302A49e3876Dff       0xBA3Cc81cfc54a4ce99638b5da1F17b15476E7231
# 3. polygon: 0xF712f9De44425d8845A1d597a247Fe88F4A23b6f       0x14CAB7829B03D075c4ae1aCF4f9156235ce99405
BRIDGE=
# The index of the contract in the system {0, 1, 2, 3}
CONTRACT_INDEX=
# The number of native NFTs the contract can mint
RANGE=
# The common part of the native metadata URL
BASE_URI=
# The common part of the wrapped URI
WRAPPED_URI=
```
#### 6. Deploy the contract

Replace the `<your-network>` with a chain name from the following list:

1. aurora
2. bsc
3. moonbeam
4. polygon

And run the command in the terminal:

```shell
npx hardhat run --network <your-network> scripts/deploy.ts
```