// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract SimpleAddition {
    function add() external pure returns (uint256) {
        // Load args
        uint256 a;
        uint256 b;

        assembly {
            a := calldataload(0x00)
            b := calldataload(0x20)
        }

        return a + b;
    }
}
