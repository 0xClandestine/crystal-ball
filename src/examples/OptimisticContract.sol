// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "solady/utils/Clone.sol";

contract OptimisticContract is Clone {
    function vevm() private pure returns (address) {
        return _getArgAddress(0x0);
    }

    function bytecodeHash() private pure returns (bytes32) {
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

        (, returnData) = vevm().delegatecall(
            abi.encodePacked(
                // runtime
                bytecode,
                // calldata
                callData,
                // runtimeLength (needed for calldata support)
                bytecode.length
            )
        );
    }
}
