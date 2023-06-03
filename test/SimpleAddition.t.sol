// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Magic.sol";

contract SimpleAddition {
    function add(uint256 a, uint256 b) external pure returns (uint256) {
        return a + b;
    }
}

contract SimpleAdditionTest is Test {
    using Magic for CrystalBall;

    CrystalBall cb;

    function setUp() public {
        cb = vevm();
    }

    function testAdd() public {
        uint256 a = 400;
        uint256 b = 20;

        bytes memory returnData = cb.delegatecall(
            type(SimpleAddition).runtimeCode,
            SimpleAddition.add.selector,
            abi.encodePacked(a, b)
        );

        assertEq(abi.decode(returnData, (uint256)), 420);
    }
}
