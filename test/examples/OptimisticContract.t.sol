// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "solady/Milady.sol";
import "../Deployer.sol";
import "../../src/examples/OptimisticContract.sol";

// Test vars
address constant player0 = 0x9C0257114EB9399a2985f8E75DAd7600c5D89fe3;
address constant player1 = 0x38E47a7b719DCE63662aeAf43440326f551b8A7E;
Oracle constant oracle = Oracle(0x89Cbf5AF14E0328a3Cd3A734F92c3832d729d431);
uint256 constant maturity = 42069;

/// @dev Simple Mock Oracle
contract Oracle {
    uint256 public price;

    function set(uint256 value) external {
        price = value;
    }
}

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

contract OptimisticContractTest is Test {
    address immutable vevm;
    address immutable optimisticContract;

    constructor() {
        vevm = deploy(CRYSTAL_BALL_BYTECODE);
        optimisticContract = address(new OptimisticContract());
        vm.deal(optimisticContract, 1 ether);
        vm.etch(address(oracle), type(Oracle).runtimeCode);
    }

    function testNormalBetDeployCost() public {
        new Bet();
    }

    function testOptimisticBetDeployCost() public {
        LibClone.clone(
            optimisticContract,
            abi.encodePacked(vevm, keccak256(type(Bet).runtimeCode))
        );
    }

    function testNormalEscrowCost() public {
        vm.pauseGasMetering();
        Bet bet = new Bet();
        vm.deal(address(bet), 1 ether);
        vm.warp(maturity + 1);
        vm.prank(player1);
        vm.resumeGasMetering();

        bet.escrow();
    }

    function testOptimisticEscrowCost() public {
        vm.pauseGasMetering();
        address bet = LibClone.clone(
            optimisticContract,
            abi.encodePacked(vevm, keccak256(type(Bet).runtimeCode))
        );
        vm.deal(address(bet), 1 ether);
        vm.warp(maturity + 1);
        vm.prank(player1);
        vm.resumeGasMetering();

        bet.call(
            abi.encode(
                type(Bet).runtimeCode, abi.encodePacked(Bet.escrow.selector)
            )
        );
    }

    function testNormalBet() public {
        Bet bet = new Bet();

        vm.deal(address(bet), 1 ether);
        vm.warp(maturity + 1);
        vm.prank(player1);
        bet.escrow();

        assertEq(address(bet).balance, 0 ether);
        assertEq(player1.balance, 1 ether);
    }

    function testOptimisticBet() public {
        address bet = LibClone.clone(
            optimisticContract,
            abi.encodePacked(vevm, keccak256(type(Bet).runtimeCode))
        );

        vm.deal(bet, 1 ether);
        vm.warp(maturity + 1);
        vm.prank(player1);
        (bool success, bytes memory returnData) = bet.call(
            abi.encode(
                type(Bet).runtimeCode, abi.encodePacked(Bet.escrow.selector)
            )
        );

        success;
        returnData;

        assertEq(bet.balance, 0 ether);
        assertEq(player1.balance, 1 ether);
    }
}
