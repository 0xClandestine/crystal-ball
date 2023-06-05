// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "solady/utils/Clone.sol";
import "../Magic.sol";

contract OptimisticContract is Clone {
    using Magic for CrystalBall;

    function vevm() public pure returns (CrystalBall) {
        return CrystalBall(_getArgAddress(0x0));
    }

    function bytecodeHash() public pure returns (bytes32) {
        return _getArgBytes32(0x14);
    }

    error Bad();

    receive() external payable virtual {}

    fallback(bytes calldata data)
        external
        payable
        virtual
        returns (bytes memory returnData)
    {
        (bytes memory bytecode, bytes memory callData) =
            abi.decode(data, (bytes, bytes));

        if (keccak256(bytecode) != bytecodeHash()) revert Bad();

        returnData = vevm().delegatecall(bytecode, callData);
    }
}
