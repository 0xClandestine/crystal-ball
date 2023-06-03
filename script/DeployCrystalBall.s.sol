// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {vevm} from "../src/Magic.sol";

contract DeployCrystalBallScript is Script {
    function run() public {
        vm.startBroadcast();
        vevm();
        vm.stopBroadcast();
    }
}
