// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "forge-std/Test.sol";
// import "src/ERC721TGNT.sol";
import "src/interfaces/IERC721TokenReceiver.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/** @dev Constants definitions */
string constant CONTRACT_NAME = "NFTTester";
string constant CONTRACT_SYMBOL = "TEST";

/** @dev Errors Definitions */
error AlreadyOwnsToken();


/** @dev Main contract with testing functionalities
 */
contract ERC72TGNTTest is Test, IERC721TokenReceiver {

    /** @dev An instance of a contract that inherits ERC721TGNT and exposes internal functions to compare gas costs */
    ERC721Tester private nftTesterOZ;

    /** @dev Initialize variables for testing. Run before each test */
    function setUp() public {
    }

    /** @dev Test constructor for variables values initialized correctly */
    function testConstructorTGNT() public {
        nftTesterOZ = new ERC721Tester();
        assertTrue(keccak256(abi.encodePacked(nftTesterOZ.name())) == keccak256(abi.encodePacked(CONTRACT_NAME)));
        assertTrue(keccak256(abi.encodePacked(nftTesterOZ.symbol())) == keccak256(abi.encodePacked(CONTRACT_SYMBOL)));
        assertTrue(nftTesterOZ.balanceOf(address(this)) == 0);
    }

    /** @dev Test minting an NFT to self */
    function testSafeMint() public {
        nftTesterOZ = new ERC721Tester();
        nftTesterOZ.safeMint(1);
        assertTrue(nftTesterOZ.balanceOf(address(this)) == 1);
        assertTrue(nftTesterOZ.ownerOf(1) == address(this));
    }

    /** @dev Test constructor for variables values initialized correctly */
    function testGasConstructorTGNT() public {
        nftTesterOZ = new ERC721Tester();
        assertTrue(true);
    }

    /** @dev Test minting an NFT to self */
    function testGasSafeMint() public {
        nftTesterOZ = new ERC721Tester();
        nftTesterOZ.safeMint(1);
        assertTrue(true);
    }



    /** @dev Implementation of IERC721TokenReceiver
     *       When calling mint from a contract address, the caller
     *       must implement onERC721Received correctly
     */
    function onERC721Received(address, address, uint256, bytes memory)
    external
    pure
    returns(bytes4) {
        return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
    }
}


// /** @notice A tester contract that inherits from {ERC721TGNT} 
//  *          Mostly to expose internal functions and test them
//  */
// contract ERC721TGNTTester is ERC721TGNT {

//     /** @dev Implementing constructor */
//     constructor() ERC721TGNT(CONTRACT_NAME, CONTRACT_SYMBOL) {}

//     /** @dev Exposes internal _safeMint function, to test it works
//      */
//     function safeMint() public {
//         super._safeMint(msg.sender);
//     } 

//     /** @dev Exposes internal _safeMint function, to test it works
//      */
//     function teamMint(address _to) public {
//         super._safeMint(_to);
//     } 

//     /** @dev Exposes internal _burn function, to test it works
//      */
//     function burn() public {
//         super._burn(uint256(uint160(msg.sender)));
//     } 

//     /** @dev Exposes internal _burn function, to test it works
//      */
//     function teamBurn(uint256 _tokenId) public {
//         super._burn(_tokenId);
//     } 

// }

/** @notice A tester contract that inherits from {ERC721} 
 *          Just to compare the gas costs between contracts
 */
contract ERC721Tester is ERC721 {

    /** @dev Implementing constructor */
    constructor() ERC721(CONTRACT_NAME, CONTRACT_SYMBOL) {}

    /** @dev Exposes internal _safeMint function, to test it works
     */
    function safeMint(uint256 _tokenId) public {
        super._safeMint(msg.sender, _tokenId);
    } 

    /** @dev Exposes internal _burn function, to test it works
     */
    function burn(uint256 _tokenId) public {
        super._burn(_tokenId);
    } 

}

