// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

library EnumerableBytes4Set {
    struct Bytes4Set {
        // Storage of set values
        bytes4[] _values;
        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping(bytes4 => uint256) _indexes;
    }

    function add(Bytes4Set storage set, bytes4 value) internal returns (bool) {
        if (!contains(set, value)) {
            set._values.push(value);
            set._indexes[value] = set._values.length;

            return true;
        } else {
            return false;
        }
    }

    function remove(Bytes4Set storage set, bytes4 value) internal returns (bool) {
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) {
            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            if (lastIndex != toDeleteIndex) {
                bytes4 lastValue = set._values[lastIndex];

                // Move the last value to the index where the value to delete is
                set._values[toDeleteIndex] = lastValue;

                // Update the index for the moved value
                set._indexes[lastValue] = valueIndex;
            }

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    function contains(Bytes4Set storage set, bytes4 value) internal view returns (bool) {
        return set._indexes[value] != 0;
    }

    function length(Bytes4Set storage set) internal view returns (uint256) {
        return set._values.length;
    }

    function at(Bytes4Set storage set, uint256 index) internal view returns (bytes4) {
        return set._values[index];
    }

    function values(Bytes4Set storage set) internal view returns (bytes4[] memory) {
        return set._values;
    }
}
