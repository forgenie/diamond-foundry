// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { Initializable } from "src/utils/Initializable.sol";
import { DiamondCutBase } from "src/facets/cut/DiamondCutBase.sol";
import { DiamondLoupeBase } from "src/facets/loupe/DiamondLoupeBase.sol";
import { IntrospectionBase } from "src/facets/introspection/IntrospectionBase.sol";

// solhint-disable-next-line no-empty-blocks
contract DiamondBase is Initializable, DiamondCutBase, DiamondLoupeBase, IntrospectionBase { }
