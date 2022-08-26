// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "forge-std/Test.sol";
import "../Whitehat.sol";
import "forge-std/console.sol";

contract whitehatTest is Test {
    address constant owner = 0x44C489197133D7076Cd9ecB33682D6Efd271c6F7;
    address constant signer = 0x3EDfd44082A87CF1b4cbB68D6Cf61F0A40d0b68f;
    address constant minter = 0xa66745F0092F7460F107E4c66C224553bF4Cd727;
    address constant minter2 = 0xDFB81A8663Df23bc59Ba75B60B99015f3F7aE725;

    // hardcoded from metabot API
    bytes32 constant r =
        0xef81487317311c6645f3f9645dd2b69f0d317804a28cad50730b1dc5ebcc26ee;
    bytes32 constant s =
        0x4395e5a1c3e5936b81a83122c2489c6de0cc0f9b1249f8d0ce3f961c85694214;
    uint8 constant v = 27;

    bytes32 constant r2 =
        0xffeaef9aa16640290e9eb1df37b21affe620e5bda658119c0c3aff63af0ff7aa;
    bytes32 constant s2 =
        0x68eecb853b5ffdd652bc2708840375d7faae077c0fdc01e9733d6690d343a922;
    uint8 constant v2 = 28;

    whitehat whitehatContract;

    constructor() {
        vm.prank(owner);
        whitehatContract = new whitehat(
            "Whitehat",
            "WHTHT",
            "NOT_IMPLEMENTED",
            1,
            "NOT_IMPLEMENTED",
            false,
            signer
        );
    }

    function setUp() public {
        vm.prank(owner);
        whitehatContract.setMintActive(true);
    }

    function testFailSetActiveByNonOwner() public {
        vm.prank(minter);
        whitehatContract.setMintActive(true);
    }

    function testMintWithSignature() public {
        emit log_uint(block.chainid);
        emit log_address(address(whitehatContract));
        vm.prank(minter);

        uint256 newTokenId = whitehatContract.mintWithSignature{
            value: 0
        }(minter, v, r, s);
        assertEq(newTokenId, 1);
    }

    function testCannotMintTwice() public {
        vm.deal(minter, 0);
        vm.prank(minter);
        whitehatContract.mintWithSignature{value: 0}(
            minter,
            v,
            r,
            s
        );
        vm.prank(minter);
        vm.expectRevert(bytes("only 1 mint per wallet address"));
        whitehatContract.mintWithSignature{value: 0}(
            minter,
            v,
            r,
            s
        );
    }

    function testMustMintForYourself() public {
        vm.deal(owner, 0);
        vm.expectRevert(bytes("you have to mint for yourself"));
        vm.prank(owner);
        whitehatContract.mintWithSignature{value: 0}(
            minter,
            v,
            r,
            s
        );
    }

    function testCannotOverpay() public {
        vm.deal(minter, 10000000000000000);
        vm.expectRevert(bytes("This mint is free"));
        vm.prank(minter);
        whitehatContract.mintWithSignature{value: 10000000000000000}(
            minter,
            v,
            r,
            s
        );
    }

    function testCannotFakeSignature() public {
        address newSigner = owner;
        vm.prank(owner);
        whitehatContract.setValidSigner(newSigner);

        vm.deal(minter, 100000000000000000);
        vm.expectRevert(bytes("Invalid signer"));
        vm.prank(minter);
        whitehatContract.mintWithSignature{value: 0}(
            minter,
            v,
            r,
            s
        );
    }

    function testContractBalance() public {
        vm.prank(minter);
        whitehatContract.mintWithSignature{value: 0}(
            minter,
            v,
            r,
            s
        );

        vm.prank(minter2);
        whitehatContract.mintWithSignature{value: 0}(
            minter2,
            v2,
            r2,
            s2
        );
        assertEq(whitehatContract.getBalance(), 0);
    }

    function testMultipleMints() public {
        vm.prank(minter);
        uint256 newTokenId = whitehatContract.mintWithSignature{
            value: 0
        }(minter, v, r, s);
        assertEq(newTokenId, 1);

        vm.prank(minter2);
        uint256 newTokenId2 = whitehatContract.mintWithSignature{
            value: 0
        }(minter2, v2, r2, s2);
        assertEq(newTokenId2, 2);
        assertEq(whitehatContract.mintedCount(), 2);
    }

    function testFailWithdrawByNonOwner() public {
        vm.prank(minter);
        whitehatContract.withdraw();
    }

    function testWithdraw() public {
        vm.prank(minter);
        whitehatContract.mintWithSignature{value: 0}(
            minter,
            v,
            r,
            s
        );

        vm.prank(minter2);
        whitehatContract.mintWithSignature{value: 0}(
            minter2,
            v2,
            r2,
            s2
        );

        vm.prank(owner);
        whitehatContract.withdraw();
        assertEq(whitehatContract.getBalance(), 0);
        assertEq(owner.balance, 0);
    }

    function testPay() public {
        vm.prank(minter);
        whitehatContract.mintWithSignature{value: 0}(
            minter,
            v,
            r,
            s
        );

        vm.prank(owner);
        whitehatContract.pay(minter2, 0);
        assertEq(whitehatContract.getBalance(), 0);
        assertEq(minter2.balance, 0);
    }

    function testFailPayByNonOwner() public {
        vm.prank(minter);
        whitehatContract.mintWithSignature{value: 0}(
            minter,
            v,
            r,
            s
        );

        whitehatContract.pay(minter2, 0);
    }
}
