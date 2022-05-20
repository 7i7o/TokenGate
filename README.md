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



___
MIT License

Copyright (c) 2022 7i7o