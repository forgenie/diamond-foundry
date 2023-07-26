// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { Initializable } from "src/utils/Initializable.sol";

contract MockInitializable is Initializable {
    // solhint-disable-next-line no-empty-blocks
    function __MockInitializable_init() internal onlyInitializing { }

    // solhint-disable-next-line no-empty-blocks
    function initialize() public initializer {
        __MockInitializable_init();
    }

    function disabledInitializer() external initializer {
        disableInitializers();
    }

    function doubleInitializer() external initializer {
        initialize();
    }

    function nonInitializer() external {
        __MockInitializable_init();
    }

    // solhint-disable-next-line no-empty-blocks
    function reinitialize(uint32 version) external reinitializer(version) { }

    function disableInitializers() public {
        _disableInitializers();
    }
}
