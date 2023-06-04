// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../Magic.sol";

contract Entrypoint {
    using Magic for CrystalBall;

    CrystalBall private immutable vevm;

    bytes32 private immutable bytecodeHash;

    constructor(CrystalBall _vevm, bytes memory _bytecode) {
        vevm = _vevm;
        bytecodeHash = keccak256(_bytecode);
    }

    error Bad();

    fallback(bytes calldata data)
        external
        payable
        virtual
        returns (bytes memory returnData)
    {
        (bytes memory bytecode, bytes4 selector, bytes memory callData) =
            abi.decode(data, (bytes, bytes4, bytes));

        if (keccak256(bytecode) != bytecodeHash) revert Bad();

        returnData = vevm.delegatecall(bytecode, selector, callData);
    }
}
