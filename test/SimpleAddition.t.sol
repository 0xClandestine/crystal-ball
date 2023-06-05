// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./Deployer.sol";
import "../src/CrystalBallStatic.sol";

contract SimpleAddition {
    function add(uint256 a, uint256 b) external pure returns (uint256) {
        return a + b;
    }
}

contract SimpleAdditionTest is Test {
    address vevm;

    function setUp() public {
        vevm = address(new CrystalBallStatic(deploy(CRYSTAL_BALL_BYTECODE)));
    }

    function testAdd() public {
        uint256 a = 400;
        uint256 b = 20;

        (, bytes memory returnData) = vevm.staticcall(
            abi.encodePacked(
                // runtime
                type(SimpleAddition).runtimeCode,
                // calldata
                SimpleAddition.add.selector,
                a,
                b,
                // runtimeLength (needed for calldata support)
                type(SimpleAddition).runtimeCode.length
            )
        );

        assertEq(abi.decode(returnData, (uint256)), 420);
    }
}
