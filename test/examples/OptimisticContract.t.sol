// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "solady/Milady.sol";
import "../../src/Magic.sol";
import "../../src/examples/OptimisticContract.sol";

contract Timelock {
    using SafeTransferLib for address;

    address constant beneficiary = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
    uint256 constant maturity = 42069;

    error Bad();
    error Wait();

    function timelock() external virtual {
        if (msg.sender != beneficiary) revert Bad();
        if (block.timestamp < maturity) revert Wait();

        beneficiary.safeTransferETH(address(this).balance);
    }
}

contract OptimisticContractTest is Test {
    using Magic for CrystalBall;

    CrystalBall vevm;
    address optimisticContract;

    function setUp() public {
        vevm = CrystalBall(address(virtualEvm()));
        optimisticContract =
            address(new Entrypoint(vevm, type(Timelock).runtimeCode));
        vm.deal(optimisticContract, 1 ether);
    }

    function testTimelock() public {
        address beneficiary = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
        uint256 maturity = 42069;

        (bool success,) = optimisticContract.call(
            abi.encode(
                type(Timelock).runtimeCode,
                Timelock.timelock.selector,
                abi.encodePacked()
            )
        );

        assertEq(optimisticContract.balance, 1 ether);
        assertEq(beneficiary.balance, 0 ether);

        vm.warp(maturity + 1);
        vm.prank(beneficiary);
        (success,)  = optimisticContract.call(
            abi.encode(
                type(Timelock).runtimeCode,
                Timelock.timelock.selector,
                abi.encodePacked()
            )
        );

        assertEq(optimisticContract.balance, 0 ether);
        assertEq(beneficiary.balance, 1 ether);
    }
}
