// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {hyvm} from "../src/LibCrystalBall.sol";

contract DeployCrystalBallScript is Script {
    function run() public {
        vm.startBroadcast();
        hyvm();
        vm.stopBroadcast();
    }
}
