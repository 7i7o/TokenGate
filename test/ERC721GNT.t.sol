// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "forge-std/Test.sol";
import "src/ERC721GNT.sol";
import "src/interfaces/IERC721TokenReceiver.sol";

/** @dev Constants definitions */
string constant CONTRACT_NAME = "NFTTester";
string constant CONTRACT_SYMBOL = "TEST";

/** @dev Errors Definitions */
error AlreadyOwnsToken();


/** @dev Main contract with testing functionalities
 */
contract ERC721GNTTest is Test, IERC721TokenReceiver {

/** @dev An instance of a contract that inherits ERC721GNT and exposes internal functions to test */
ERC721GNTTester private nftTester;

    /** @dev Initialize variables for testing. Run before each test */
    function setUp() public {
        nftTester = new ERC721GNTTester();
    }

    /** @dev Test constructor for variables values initialized correctly */
    function testConstructor() public {
        assertTrue(keccak256(abi.encodePacked(nftTester.name())) == keccak256(abi.encodePacked(CONTRACT_NAME)));
        assertTrue(keccak256(abi.encodePacked(nftTester.symbol())) == keccak256(abi.encodePacked(CONTRACT_SYMBOL)));
        assertTrue(nftTester.balanceOf(msg.sender) == 0);
    }

    /** @dev Test minting an NFT to self */
    function testSafeMint() public {
        console2.log("Mint a token. From tester contract address: ", address(this));
        nftTester.safeMint();
        assertTrue(nftTester.balanceOf(address(this)) == 1);
        assertTrue(nftTester.ownerOf(uint256(uint160(address(this)))) == address(this));
    }

    /** @dev Test minting an NFT to another address */
    function testTeamMint() public {
        console2.log("Mint a token from team. To msg.sender address: ", msg.sender);
        nftTester.teamMint(msg.sender);
        assertTrue(nftTester.balanceOf(msg.sender) == 1);
        assertTrue(nftTester.ownerOf(uint256(uint160(msg.sender))) == msg.sender);
    }

    /** @dev Test minting and burning an NFT */
    function testBurn() public {
        console2.log("Mint a token. From tester contract address: ", address(this));
        nftTester.safeMint();
        console2.log("Burn a token. From tester contract address: ", address(this));
        nftTester.burn();
        assertTrue(nftTester.balanceOf(address(this)) == 0);
    }

    /** @dev Test minting an NFT and then trying to mint another (expect revert) */
    function testExpectRevertOnDoubleMint() public {
        console2.log("Mint a token. From tester contract address: ", address(this));
        nftTester.safeMint();
        console2.log("Mint another token. From tester contract address: ", address(this));
        vm.expectRevert(abi.encodeWithSelector(ERC721GNT.AlreadyOwnsToken.selector, address(this)));
        nftTester.safeMint();
    }

    /** @dev Test querying for a tokenId that wasn't minted (expect revert) */
    function testExpectRevertNonExistentToken() public {
        console2.log("Call to ownerOf: ", address(this));
        vm.expectRevert(abi.encodeWithSelector(ERC721GNT.NonExistentTokenId.selector,uint256(uint160(address(this)))));
        nftTester.ownerOf(uint256(uint160(address(this))));
    }

    /** @dev Test querying for balance of address 0x0 (expect revert) */
    function testExpectRevertAddressZero() public {
        console2.log("Call to balanceOf: ", address(0x0));
        vm.expectRevert(ERC721GNT.ZeroAddressQuery.selector);
        nftTester.balanceOf(address(0x0));
    }

    /** @dev Test Approvals (expect revert) */
    function testExpectRevertApproval() public {
        console2.log("Mint a token. From tester contract address: ", address(this));
        nftTester.safeMint();
        console2.log("approve. To address: ", msg.sender);
        vm.expectRevert(ERC721GNT.TransferAndApprovalsDisabled.selector);
        nftTester.approve(msg.sender, uint256(uint160(address(this))));
        console2.log("setApprovalForAll: ", address(0x0), true);
        vm.expectRevert(ERC721GNT.TransferAndApprovalsDisabled.selector);
        nftTester.setApprovalForAll(address(0x0), true);
    }

    /** @dev Test Transfers (expect revert) */
    function testExpectRevertTransfers() public {
        console2.log("Mint a token. From tester contract address: ", address(this));
        nftTester.safeMint();
        console2.log("transferFrom. To address: ", msg.sender);
        vm.expectRevert(ERC721GNT.TransferAndApprovalsDisabled.selector);
        nftTester.transferFrom(address(this), msg.sender, uint256(uint160(address(this))));
        console2.log("safeTransferFrom. To address: ", msg.sender);
        vm.expectRevert(ERC721GNT.TransferAndApprovalsDisabled.selector);
        nftTester.safeTransferFrom(address(this), msg.sender, uint256(uint160(address(this))));
        console2.log("safeTransferFrom (with data). To address: ", msg.sender);
        vm.expectRevert(ERC721GNT.TransferAndApprovalsDisabled.selector);
        nftTester.safeTransferFrom(address(this), msg.sender, uint256(uint160(address(this))), "");
    }

    /** @dev Test minting from an EAO address */
    function testMintFromAnEOAAddress() public {
        console2.log("Mint a token from other address. From address: ", address(1));
        vm.prank(address(1));
        nftTester.safeMint();
        assertTrue(nftTester.balanceOf(address(1)) == 1);
    }

    /** @dev Test minting from a smart contract address that doesn't implement IERC721TokenReceiver (expect revert) */
    function testExpectRevertMintFromIncorrectContract() public {
        console2.log("Mint a token from other address. From address: ", address(nftTester));
        vm.prank(address(nftTester));
        vm.expectRevert(abi.encodeWithSelector(ERC721GNT.OnERC721ReceivedNotOk.selector,address(nftTester)));
        nftTester.safeMint();
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


/** @notice A tester contract that inherits from {ERC721GNT} 
 *          Mostly to expose internal functions and test them
 */
contract ERC721GNTTester is ERC721GNT {

    /** @dev Implementing constructor */
    constructor() ERC721GNT(CONTRACT_NAME, CONTRACT_SYMBOL) {}

    /** @dev Exposes internal _safeMint function, to test it works
     */
    function safeMint() public {
        super._safeMint(msg.sender);
    } 

    /** @dev Exposes internal _safeMint function, to test it works
     */
    function teamMint(address _to) public {
        super._safeMint(_to);
    } 

    /** @dev Exposes internal _burn function, to test it works
     */
    function burn() public {
        super._burn(uint256(uint160(msg.sender)));
    } 
}

