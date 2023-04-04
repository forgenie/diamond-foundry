// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface IMockFacet {
    function mockFunction() external pure returns (uint256);
}

contract MockFacet is IMockFacet {
    function mockFunction() public pure returns (uint256) {
        return 420;
    }
}
