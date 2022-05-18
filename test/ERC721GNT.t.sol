// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "forge-std/Test.sol";
import "src/ERC721GNT.sol";

contract ERC721GNTTest is Test {

ERC721GNT private nftContract;

    function setUp() public {
        nftContract = new ERC721GNT('Token', 'TKN');
    }

    function testNameAndSymbol() public {
        assertTrue(keccak256(abi.encodePacked(nftContract.name())) == keccak256(abi.encodePacked('Token')));
        assertTrue(keccak256(abi.encodePacked(nftContract.symbol())) == keccak256(abi.encodePacked('TKN')));
    }
}
