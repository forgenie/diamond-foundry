// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { Script } from "forge-std/Script.sol";

abstract contract BaseScript is Script {
    address public deployer;

    modifier broadcast() {
        vm.startBroadcast();
        _;
        vm.stopBroadcast();
    }

    function setUp() public virtual {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        deployer = vm.rememberKey(privateKey);
    }

    function run() public virtual;
}
