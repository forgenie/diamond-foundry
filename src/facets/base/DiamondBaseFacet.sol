// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import { Initializable } from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import { DiamondIncremental, IDiamondIncremental } from "src/facets/incremental/DiamondIncremental.sol";
import { DiamondCut, IDiamondCut } from "src/facets/cut/DiamondCut.sol";
import { DiamondLoupe, IDiamondLoupe } from "src/facets/loupe/DiamondLoupe.sol";
import { Ownable, OwnableBehavior, IERC173 } from "src/facets/ownable/Ownable.sol";
import { Introspection, IntrospectionBehavior, IERC165 } from "src/facets/introspection/Introspection.sol";

contract DiamondBaseFacet is DiamondCut, DiamondLoupe, Ownable, Introspection, DiamondIncremental, Initializable {
    /// @dev Prevents initializer from being called in the implementation.
    constructor() {
        _disableInitializers();
    }

    function initialize(address owner_) external initializer {
        OwnableBehavior.transferOwnership(owner_);

        IntrospectionBehavior.addInterface(type(IDiamondIncremental).interfaceId);
        IntrospectionBehavior.addInterface(type(IDiamondLoupe).interfaceId);
        IntrospectionBehavior.addInterface(type(IDiamondCut).interfaceId);
        IntrospectionBehavior.addInterface(type(IERC165).interfaceId);
        IntrospectionBehavior.addInterface(type(IERC173).interfaceId);
    }

    function _authorizeDiamondCut() internal override onlyOwner {
        // solhint-disable-previous-line no-empty-blocks
    }

    function _authorizeImmute() internal override onlyOwner {
        // solhint-disable-previous-line no-empty-blocks
    }
}
