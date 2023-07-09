// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { Script } from "forge-std/Script.sol";

contract BaseScript is Script {
    address internal deployer;

    modifier broadcaster() {
        vm.startBroadcast(deployer);
        _;
        vm.stopBroadcast();
    }

    function setUp() public virtual {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        deployer = vm.rememberKey(privateKey);
    }
}
