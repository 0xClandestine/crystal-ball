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

// example usage
(bool success, bytes memory returnData) = cb.delegatecall(
    abi.encodePacked(
        type(SimpleAddition).runtimeCode,
        abi.encodeCall(SimpleAddition.add, (a, b))
        runtimeCode.length
    )
);

uint256 sum = abi.decode(returnData, (uint256));
```

## Usecases:

- `Optimistic contracts` - Deploy unique contracts for the cost of a clone with 52-bytes of immutable arg data.


### Example:
```solidity
address constant player0 = 0x9C0257114EB9399a2985f8E75DAd7600c5D89fe3;
address constant player1 = 0x38E47a7b719DCE63662aeAf43440326f551b8A7E;
Oracle constant oracle = Oracle(0x89Cbf5AF14E0328a3Cd3A734F92c3832d729d431);
uint256 constant maturity = 42069;

/// @dev Simple bet between two addresses
contract Bet {
    event BalanceTransfer(address winner, uint256 amount);

    using SafeTransferLib for address;

    error Bad();
    error Wait();

    function escrow() external virtual {
        if (msg.sender != player0 && msg.sender != player1) revert Bad();
        if (block.timestamp < maturity) revert Wait();

        address winner = oracle.price() > 1500 ether ? player0 : player1;
        uint256 balance = address(this).balance;

        winner.safeTransferETH(balance);
        emit BalanceTransfer(winner, balance);
    }
}
```

| Transaction      | Gas cost              |
|---------------------|-------------------------|
| Normal `Bet` deployment   |  `145,594`  |
| Optimistic `Bet` deployment | `63,465`         |
| Savings | `82,129`         |

| Transaction      | Gas cost              |
|---------------------|-------------------------|
| Normal `escrow()` call   |  `42,131`  |
| Optimistic `escrow()` call   | `72,328`         |
| Savings | `-30,197`         |

| Transaction      | Gas cost              |
|---------------------|-------------------------|
| Normal `Bet` deployment + `escrow()` call    |  `187,725`  |
| Optimistic `Bet` deployment + `escrow()` call    | `135,793`         |
| Savings | `51,932`         |


## 🔮 / EVM divergence
- `calldataload`: assumes calldata, and runtimeCode.length are appended to bytecode.
- `calldatasize`: assumes calldata, and runtimeCode.length are appended to bytecode. 
- `calldatacopy`: assumes calldata, and runtimeCode.length are appended to bytecode.
- `selfdestruct`: reverts to prevent malicious or erroneous selfdestruct
- `jumpdest`: as mentioned in the disclaimer, there is no check to ensure the validity of the opcode.
- `codesize`: returns the calldatasize, not the VM size
- `callcode` will revert : it is deprecated and generally considered unsafe.
- `codecopy`: copies from the calldata, not the code

## Acknowledgments

This would not be possible without Nested.fi ❤️