// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { FacetTest, FacetHelper } from "../Facet.t.sol";
import { AccessControlFacet, IAccessControl } from "src/facets/access-control/AccessControlFacet.sol";
import { IDiamond, Diamond } from "src/diamond/Diamond.sol";
import { IAccessControlBase } from "src/facets/access-control/IAccessControl.sol";

abstract contract AccessControlFacetTest is IAccessControlBase, FacetTest {
    IAccessControl public acl;

    function setUp() public virtual override {
        super.setUp();

        acl = IAccessControl(diamond);
    }

    function diamondInitParams() public override returns (Diamond.InitParams memory) {
        AccessControlFacetHelper aclHelper = new AccessControlFacetHelper();

        FacetCut[] memory baseFacets = new FacetCut[](1);
        baseFacets[0] = aclHelper.makeFacetCut(FacetCutAction.Add);

        return Diamond.InitParams({
            baseFacets: baseFacets,
            init: aclHelper.facet(),
            initData: abi.encodeWithSelector(aclHelper.initializer(), users.admin)
        });
    }
}

contract AccessControlFacetHelper is FacetHelper {
    AccessControlFacet public acl;

    constructor() {
        acl = new AccessControlFacet();
    }

    function facet() public view override returns (address) {
        return address(acl);
    }

    function selectors() public view override returns (bytes4[] memory selectors_) {
        selectors_ = new bytes4[](7);
        selectors_[0] = acl.setFunctionAccess.selector;
        selectors_[1] = acl.setUserRole.selector;
        selectors_[2] = acl.canCall.selector;
        selectors_[3] = acl.userRoles.selector;
        selectors_[4] = acl.functionRoles.selector;
        selectors_[5] = acl.hasRole.selector;
        selectors_[6] = acl.roleHasAccess.selector;
    }

    function initializer() public view override returns (bytes4) {
        return acl.AccessControl_init.selector;
    }

    function supportedInterfaces() public pure override returns (bytes4[] memory interfaces) {
        interfaces = new bytes4[](1);
        interfaces[0] = type(IAccessControl).interfaceId;
    }

    function creationCode() public pure override returns (bytes memory) {
        return type(AccessControlFacet).creationCode;
    }

    function makeInitData(bytes memory args) public view override returns (MultiInit memory) {
        return
            MultiInit({ init: facet(), initData: abi.encodeWithSelector(initializer(), abi.decode(args, (address))) });
    }
}
