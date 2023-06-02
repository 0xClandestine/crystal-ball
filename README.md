# 🔮 Crystal-ball 

Fork of [HyVM](https://github.com/oguimbal/HyVM) with unconventional calldata support.

## Why is this magic? 

The HyVM enables arbitrary bytecode execution on the Ethereum Virtual Machine (EVM) without the need to deploy a tangible contract.

This brew of the HyVM adds calldata support. Since the bytecode that's sent to the HyVM is actually calldata we have to make some unconventional changes. In order to properly load calldata this brew assumes the bytecode sent to the HyVM is encoded as follows:

```solidity
// example contract
contract SimpleAddition {
    function add(uint256 a, uint256 b) external pure returns (uint256) {
        return a + b;
    }
}

// runtime
abi.encodePacked(
    type(SimpleAddition).runtimeCode,
    hex"00000000",
    abi.encodePacked(a, b),
    runtimeCode.length
);
```

## 🔮 / EVM divergence
- `calldataload`: assumes calldata, and runtimeCode.length are appended to bytecode.
- `calldatasize`: assumes calldata, and runtimeCode.length are appended to bytecode. 
- `calldatacopy`: copies zeros in the specified location
- `selfdestruct`: reverts to prevent malicious or erroneous selfdestruct
- `jumpdest`: as mentioned in the disclaimer, there is no check to ensure the validity of the opcode.
- `codesize`: returns the calldatasize, not the VM size
- `callcode` will revert : it is deprecated and generally considered unsafe.
- `codecopy`: copies from the calldata, not the code

## Acknowledgments

This would not be possible without Nested.fi ❤️