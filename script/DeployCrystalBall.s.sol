// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../test/Deployer.sol";

contract DeployCrystalBallScript is Script {
    function run() public {
        vm.startBroadcast();
        deploy(CRYSTAL_BALL_BYTECODE);
        vm.stopBroadcast();
    }
}
