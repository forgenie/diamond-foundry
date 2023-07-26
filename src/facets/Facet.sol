// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { Initializable } from "src/utils/Initializable.sol";
import { DelegateContext } from "src/utils/DelegateContext.sol";
import { DiamondLoupeBase } from "src/facets/loupe/DiamondLoupeBase.sol";
import { IERC165 } from "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import { IAccessControl } from "src/facets/access-control/IAccessControl.sol";
import { IERC173 } from "src/facets/ownable/IERC173.sol";

abstract contract Facet is Initializable, DelegateContext, DiamondLoupeBase {
    error CallerIsNotOwner();
    error CallerIsNotAuthorized();

    constructor() {
        _disableInitializers();
    }

    /// @dev Reverts if the caller is not the owner or does not have role access to the function.
    modifier protected() {
        if (IERC165(address(this)).supportsInterface(type(IAccessControl).interfaceId)) {
            if (!IAccessControl(address(this)).canCall(msg.sender, msg.sig)) {
                revert CallerIsNotAuthorized();
            }
        } else if (msg.sender != IERC173(address(this)).owner()) {
            revert CallerIsNotOwner();
        }
        _;
    }

    modifier onlyDiamondOwner() {
        if (msg.sender != IERC173(address(this)).owner()) revert CallerIsNotOwner();
        _;
    }

    modifier onlyDiamondAuthorized() {
        if (!IAccessControl(address(this)).canCall(msg.sender, msg.sig)) revert CallerIsNotAuthorized();
        _;
    }

    // Consider hardcoding interfaceIds in a noDelegateCall function.
    // function supportedInterfaces() public noDelegateCall view virtual returns (bytes4[] memory);
}
