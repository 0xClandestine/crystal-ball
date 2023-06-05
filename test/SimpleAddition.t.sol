// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Magic.sol";
import "../src/CrystalBallStatic.sol";

contract SimpleAddition {
    function add(uint256 a, uint256 b) external pure returns (uint256) {
        return a + b;
    }
}

contract SimpleAdditionTest is Test {
    using Magic for CrystalBall;

    CrystalBall vevm;

    function setUp() public {
        vevm =
            CrystalBall(address(new CrystalBallStatic(address(virtualEvm()))));
    }

    function testAdd() public {
        uint256 a = 400;
        uint256 b = 20;

        bytes memory returnData = vevm.staticcall(
            type(SimpleAddition).runtimeCode,
            abi.encodePacked(SimpleAddition.add.selector, a, b)
        );

        assertEq(abi.decode(returnData, (uint256)), 420);
    }
}
