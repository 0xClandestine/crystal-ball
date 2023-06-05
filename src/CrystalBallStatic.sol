// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract CrystalBallStatic {
    address public immutable vevm;

    constructor(address _vevm) {
        vevm = _vevm;
    }

    error BadDelegatecall();

    function delegatecall(bytes calldata callData)
        external
        virtual
        returns (bytes memory)
    {
        if (msg.sender != address(this)) revert();
        (bool success, bytes memory data) = vevm.delegatecall(callData);
        if (!success) revert BadDelegatecall();
        return data;
    }

    error BadStaticcall();

    fallback(bytes calldata callData) external virtual returns (bytes memory) {
        (bool success, bytes memory data) = address(this).staticcall(
            abi.encodeCall(this.delegatecall, callData)
        );

        if (!success) revert BadStaticcall();

        return abi.decode(data, (bytes));
    }
}
