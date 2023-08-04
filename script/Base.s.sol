// SPDX-License-Identifier: MIT License
pragma solidity >=0.8.19;

import { Script } from "forge-std/Script.sol";
import { FacetHelper } from "test/facets/Facet.t.sol";

import { DiamondCutFacetHelper } from "test/facets/cut/cut.t.sol";
import { DiamondLoupeFacetHelper } from "test/facets/loupe/loupe.t.sol";
import { AccessControlFacetHelper } from "test/facets/access-control/access-control.t.sol";
import { OwnableFacetHelper } from "test/facets/ownable/ownable.t.sol";
import { Ownable2StepFacetHelper } from "test/facets/ownable2step/ownable2step.t.sol";
import { NFTOwnedFacetHelper } from "test/facets/nft-owned/nft-owned.t.sol";
import { ERC20FacetHelper } from "test/facets/erc20/erc20.t.sol";
import { ERC20MintableFacetHelper } from "test/facets/erc20-mintable/erc20-mintable.t.sol";
import { ERC20BurnableFacetHelper } from "test/facets/erc20-burnable/erc20-burnable.t.sol";

contract BaseScript is Script {
    address internal deployer;
    bytes32 internal salt;
    FacetHelper[] internal facetHelpers;

    modifier broadcaster() {
        vm.startBroadcast(deployer);
        _;
        vm.stopBroadcast();
    }

    function setUp() public virtual {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        deployer = vm.rememberKey(privateKey);
        salt = vm.envBytes32("SALT");

        facetHelpers.push(new DiamondCutFacetHelper());
        facetHelpers.push(new DiamondLoupeFacetHelper());
        facetHelpers.push(new AccessControlFacetHelper());
        facetHelpers.push(new OwnableFacetHelper());
        facetHelpers.push(new Ownable2StepFacetHelper());
        facetHelpers.push(new NFTOwnedFacetHelper());
        facetHelpers.push(new ERC20FacetHelper());
        facetHelpers.push(new ERC20MintableFacetHelper());
        facetHelpers.push(new ERC20BurnableFacetHelper());
    }
}
