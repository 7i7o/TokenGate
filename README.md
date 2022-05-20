# ERC721TGNT (NFTs for Token Gating, Non-Transferable)

## ERC721 Non-Transferable Implementation, focused on saving gas for Token Gating

### Using owner Address as TokenId

The intent of this implementation is to save as much gas as possible by trimming down on storage and evm instructions from the stardard implementations (being OpenZeppelin's the most widely used).

The use of common implementations depend on storing data for owner, id, approved and (multiple) approvedForAll, and using this for common tokenGating wastes a lot of gas on deploying contracts and more importantly minting, which wastes users gas.

Since the objective of token gating is allowing access of an address by checking a token ownership, several use cases don't need this access being exchanged on secondary markets. By removing these transfers, there's no need for approvals or aperators, allowing us to improve gas use on the smart contract thus making deployment, minting and burning far more efficient.

This implementation aims to provide a way for users and developers to take advantage of this and saving gas by inheriting it.

This project was developed using the [Foundry](getfoundry.sh) smart contract development toolchain.
## Installing

### npm

If you use npm, you can install by running: 

```bash
npm i @7i7o/tokengate
```

### Foundry

If you are using Foundry (or Forge)just run:

```bash
forge install 7i7o/TokenGate
```

and add a line in your remappings.txt file (it should sit on your main project folder) with:

```
@7i7o/tokengate=lib/TokenGate/
```

## Usage

Now you can import it in your solidity files like this:

```solidity
import "@7i7o/tokengate/src/ERC721TGNT.sol";
```

To inherit this, you need to implement the contructor on your contract and pass a `Name` and a `Symbol` for your NFTs, like this:

```solidity
contract Contract is ERC721TGNT {

    constructor() ERC721TGNT("Name", "Symbol") {}

}
```

## Dev Instructions

To tinker with the implementation, you only need to fork this repo and start hacking.

To build (compile) you can run:

```bash
forge build
```

to build, run:

```bash
forge test
```

## Gas Comparison

To have a estimate of gas savings for users and deployers, i ran basic tests deploying a basic contract that inherited OpenZeppelin's ERC721 and another set that inherited ERC721TGNT, both exposing basic _safeMint functionality.

I ran one test for creating a new contract, and another to create the contract and mint 1 token (to measure only minting gas).

The results of gas spent in each test for each contract can be seen in the table below

| Function      |     TGNT      | OpenZeppelin  |  % Gas Saved by TGNT |
| ------------- |--------------:| -------------:|---------------------:|
| `deploy`      |        649500 |       1168364 |               44.41% |
| `safeMint`    |         26930 |         49462 |               45.55% |

That's roughly **45%** gas saving on both **deploy** and **mint**.


## Example of deployment

To see an example of usage, the contract has been inherited and deployed on Polygon Mainnet, with the address [`0x0c6c2a028ab0fcb9e60f82ce14703eef40d15a48`](https://polygonscan.com/address/0x0c6c2a028ab0fcb9e60f82ce14703eef40d15a48#code) 



___
MIT License

Copyright (c) 2022 7i7o