// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { FacetHelper } from "test/facets/Facet.t.sol";

interface IMockFacet {
    function mockFunction() external pure returns (uint256);
}

contract MockFacet is IMockFacet {
    function mockFunction() public pure returns (uint256) {
        return 420;
    }
}

contract MockFacetHelper is FacetHelper {
    MockFacet internal mockFacet;

    constructor() {
        mockFacet = new MockFacet();
    }

    function facet() public view override returns (address) {
        return address(mockFacet);
    }

    function selectors() public pure override returns (bytes4[] memory selectors_) {
        selectors_ = new bytes4[](1);
        selectors_[0] = MockFacet.mockFunction.selector;
    }

    function initializer() public pure override returns (bytes4) {
        return bytes4(0);
    }

    function supportedInterfaces() public pure override returns (bytes4[] memory interfaces) {
        interfaces = new bytes4[](1);
        interfaces[0] = type(IMockFacet).interfaceId;
    }

    function creationCode() public pure override returns (bytes memory) {
        return type(MockFacet).creationCode;
    }
}
