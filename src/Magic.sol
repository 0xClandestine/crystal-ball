// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

abstract contract CrystalBall {}

/// @dev Creates a virtual-evm instance.
function vevm() returns (CrystalBall instance) {
    bytes memory creationCode = HYVM_BYTECODE;
    assembly {
        instance := create(0, add(creationCode, 0x20), mload(creationCode))

        if iszero(instance) { revert(0, 0) }
    }
}

library Magic {
    // vevm().delegatecall(bytecode, selector, calldata)
    function delegatecall(
        CrystalBall vevm,
        bytes memory bytecode,
        bytes4 selector,
        bytes memory callData
    ) internal returns (bytes memory) {
        (, bytes memory returnData) = address(vevm).delegatecall(
            abi.encodePacked(
                replaceFirst(
                    bytecode, abi.encodePacked(selector), (hex"00000000")
                ),
                bytes4(hex"00000000"),
                callData,
                bytecode.length
            )
        );

        return returnData;
    }

    function replaceFirst(
        bytes memory data,
        bytes memory replace,
        bytes memory with
    ) internal pure returns (bytes memory output) {
        unchecked {
            uint256 dataLen = data.length;
            uint256 replaceLen = replace.length;
            uint256 withLen = with.length;

            if (replaceLen == 0 || dataLen < replaceLen) {
                return data;
            }

            output = new bytes(dataLen - replaceLen + withLen);

            for (uint256 i; i <= dataLen - replaceLen; ++i) {
                bool matches = true;

                for (uint256 j; j < replaceLen; ++j) {
                    if (data[i + j] != replace[j]) {
                        matches = false;
                        break;
                    }
                }

                if (matches) {
                    // Copy the data before the replaced portion
                    for (uint256 k; k < i; ++k) {
                        output[k] = data[k];
                    }

                    // Copy the replacement
                    for (uint256 k; k < withLen; ++k) {
                        output[i + k] = with[k];
                    }

                    // Copy the remaining data after the replaced portion
                    for (uint256 k = i + replaceLen; k < dataLen; ++k) {
                        output[k + withLen - replaceLen] = data[k];
                    }

                    break;
                }
            }
        }
    }
}

bytes constant HYVM_BYTECODE =
    hex"601680803090380352380380916000396020016000f36020803803610220396102205173ffffffffffffffffffffffffffffffffffffffff1630146113ed576000602061034003526102006114dd602039600051803560f81c906001016000526002026020015160f01c565b5b00600051803560f81c906001016000526002026020015160f01c565b01600051803560f81c906001016000526002026020015160f01c565b02600051803560f81c906001016000526002026020015160f01c565b03600051803560f81c906001016000526002026020015160f01c565b04600051803560f81c906001016000526002026020015160f01c565b05600051803560f81c906001016000526002026020015160f01c565b06600051803560f81c906001016000526002026020015160f01c565b07600051803560f81c906001016000526002026020015160f01c565b08600051803560f81c906001016000526002026020015160f01c565b09600051803560f81c906001016000526002026020015160f01c565b0a600051803560f81c906001016000526002026020015160f01c565b0b600051803560f81c906001016000526002026020015160f01c565b10600051803560f81c906001016000526002026020015160f01c565b11600051803560f81c906001016000526002026020015160f01c565b12600051803560f81c906001016000526002026020015160f01c565b13600051803560f81c906001016000526002026020015160f01c565b14600051803560f81c906001016000526002026020015160f01c565b15600051803560f81c906001016000526002026020015160f01c565b16600051803560f81c906001016000526002026020015160f01c565b17600051803560f81c906001016000526002026020015160f01c565b18600051803560f81c906001016000526002026020015160f01c565b19600051803560f81c906001016000526002026020015160f01c565b1a600051803560f81c906001016000526002026020015160f01c565b1b600051803560f81c906001016000526002026020015160f01c565b1c600051803560f81c906001016000526002026020015160f01c565b1d600051803560f81c906001016000526002026020015160f01c565b73ffffffffffffffffffffffffffffffffffffffff166103400120600051803560f81c906001016000526002026020015160f01c565b30600051803560f81c906001016000526002026020015160f01c565b31600051803560f81c906001016000526002026020015160f01c565b32600051803560f81c906001016000526002026020015160f01c565b33600051803560f81c906001016000526002026020015160f01c565b34600051803560f81c906001016000526002026020015160f01c565b60203603350135600051803560f81c906001016000526002026020015160f01c565b602080360335360303600051803560f81c906001016000526002026020015160f01c565b73ffffffffffffffffffffffffffffffffffffffff1661034001906020360335019037600051803560f81c906001016000526002026020015160f01c565b36600051803560f81c906001016000526002026020015160f01c565b73ffffffffffffffffffffffffffffffffffffffff166103400137600051803560f81c906001016000526002026020015160f01c565b3a600051803560f81c906001016000526002026020015160f01c565b3b600051803560f81c906001016000526002026020015160f01c565b9073ffffffffffffffffffffffffffffffffffffffff1661034001903c600051803560f81c906001016000526002026020015160f01c565b3d600051803560f81c906001016000526002026020015160f01c565b73ffffffffffffffffffffffffffffffffffffffff16610340013e600051803560f81c906001016000526002026020015160f01c565b3f600051803560f81c906001016000526002026020015160f01c565b40600051803560f81c906001016000526002026020015160f01c565b41600051803560f81c906001016000526002026020015160f01c565b42600051803560f81c906001016000526002026020015160f01c565b43600051803560f81c906001016000526002026020015160f01c565b44600051803560f81c906001016000526002026020015160f01c565b45600051803560f81c906001016000526002026020015160f01c565b46600051803560f81c906001016000526002026020015160f01c565b47600051803560f81c906001016000526002026020015160f01c565b48600051803560f81c906001016000526002026020015160f01c565b50600051803560f81c906001016000526002026020015160f01c565b73ffffffffffffffffffffffffffffffffffffffff166103400151600051803560f81c906001016000526002026020015160f01c565b73ffffffffffffffffffffffffffffffffffffffff166103400152600051803560f81c906001016000526002026020015160f01c565b73ffffffffffffffffffffffffffffffffffffffff166103400153600051803560f81c906001016000526002026020015160f01c565b54600051803560f81c906001016000526002026020015160f01c565b55600051803560f81c906001016000526002026020015160f01c565b803560f81c90600101600052605b14156107c557600051803560f81c906001016000526002026020015160f01c565b60006000fd5b906107965750600051803560f81c906001016000526002026020015160f01c565b600160005103600051803560f81c906001016000526002026020015160f01c565b600073ffffffffffffffffffffffffffffffffffffffff16610340015903600051803560f81c906001016000526002026020015160f01c565b5a600051803560f81c906001016000526002026020015160f01c565b600051803560f81c906001016000526002026020015160f01c565b60016000518035826020036008021c9101600052600051803560f81c906001016000526002026020015160f01c565b60026000518035826020036008021c9101600052600051803560f81c906001016000526002026020015160f01c565b60036000518035826020036008021c9101600052600051803560f81c906001016000526002026020015160f01c565b60046000518035826020036008021c9101600052600051803560f81c906001016000526002026020015160f01c565b60056000518035826020036008021c9101600052600051803560f81c906001016000526002026020015160f01c565b60066000518035826020036008021c9101600052600051803560f81c906001016000526002026020015160f01c565b60076000518035826020036008021c9101600052600051803560f81c906001016000526002026020015160f01c565b60086000518035826020036008021c9101600052600051803560f81c906001016000526002026020015160f01c565b60096000518035826020036008021c9101600052600051803560f81c906001016000526002026020015160f01c565b600a6000518035826020036008021c9101600052600051803560f81c906001016000526002026020015160f01c565b600b6000518035826020036008021c9101600052600051803560f81c906001016000526002026020015160f01c565b600c6000518035826020036008021c9101600052600051803560f81c906001016000526002026020015160f01c565b600d6000518035826020036008021c9101600052600051803560f81c906001016000526002026020015160f01c565b600e6000518035826020036008021c9101600052600051803560f81c906001016000526002026020015160f01c565b600f6000518035826020036008021c9101600052600051803560f81c906001016000526002026020015160f01c565b60106000518035826020036008021c9101600052600051803560f81c906001016000526002026020015160f01c565b60116000518035826020036008021c9101600052600051803560f81c906001016000526002026020015160f01c565b60126000518035826020036008021c9101600052600051803560f81c906001016000526002026020015160f01c565b60136000518035826020036008021c9101600052600051803560f81c906001016000526002026020015160f01c565b60146000518035826020036008021c9101600052600051803560f81c906001016000526002026020015160f01c565b60156000518035826020036008021c9101600052600051803560f81c906001016000526002026020015160f01c565b60166000518035826020036008021c9101600052600051803560f81c906001016000526002026020015160f01c565b60176000518035826020036008021c9101600052600051803560f81c906001016000526002026020015160f01c565b60186000518035826020036008021c9101600052600051803560f81c906001016000526002026020015160f01c565b60196000518035826020036008021c9101600052600051803560f81c906001016000526002026020015160f01c565b601a6000518035826020036008021c9101600052600051803560f81c906001016000526002026020015160f01c565b601b6000518035826020036008021c9101600052600051803560f81c906001016000526002026020015160f01c565b601c6000518035826020036008021c9101600052600051803560f81c906001016000526002026020015160f01c565b601d6000518035826020036008021c9101600052600051803560f81c906001016000526002026020015160f01c565b601e6000518035826020036008021c9101600052600051803560f81c906001016000526002026020015160f01c565b601f6000518035826020036008021c9101600052600051803560f81c906001016000526002026020015160f01c565b60206000518035826020036008021c9101600052600051803560f81c906001016000526002026020015160f01c565b80600051803560f81c906001016000526002026020015160f01c565b81600051803560f81c906001016000526002026020015160f01c565b82600051803560f81c906001016000526002026020015160f01c565b83600051803560f81c906001016000526002026020015160f01c565b84600051803560f81c906001016000526002026020015160f01c565b85600051803560f81c906001016000526002026020015160f01c565b86600051803560f81c906001016000526002026020015160f01c565b87600051803560f81c906001016000526002026020015160f01c565b88600051803560f81c906001016000526002026020015160f01c565b89600051803560f81c906001016000526002026020015160f01c565b8a600051803560f81c906001016000526002026020015160f01c565b8b600051803560f81c906001016000526002026020015160f01c565b8c600051803560f81c906001016000526002026020015160f01c565b8d600051803560f81c906001016000526002026020015160f01c565b8e600051803560f81c906001016000526002026020015160f01c565b8f600051803560f81c906001016000526002026020015160f01c565b90600051803560f81c906001016000526002026020015160f01c565b91600051803560f81c906001016000526002026020015160f01c565b92600051803560f81c906001016000526002026020015160f01c565b93600051803560f81c906001016000526002026020015160f01c565b94600051803560f81c906001016000526002026020015160f01c565b95600051803560f81c906001016000526002026020015160f01c565b96600051803560f81c906001016000526002026020015160f01c565b97600051803560f81c906001016000526002026020015160f01c565b98600051803560f81c906001016000526002026020015160f01c565b99600051803560f81c906001016000526002026020015160f01c565b9a600051803560f81c906001016000526002026020015160f01c565b9b600051803560f81c906001016000526002026020015160f01c565b9c600051803560f81c906001016000526002026020015160f01c565b9d600051803560f81c906001016000526002026020015160f01c565b9e600051803560f81c906001016000526002026020015160f01c565b9f600051803560f81c906001016000526002026020015160f01c565b73ffffffffffffffffffffffffffffffffffffffff1661034001a0600051803560f81c906001016000526002026020015160f01c565b73ffffffffffffffffffffffffffffffffffffffff1661034001a1600051803560f81c906001016000526002026020015160f01c565b73ffffffffffffffffffffffffffffffffffffffff1661034001a2600051803560f81c906001016000526002026020015160f01c565b73ffffffffffffffffffffffffffffffffffffffff1661034001a3600051803560f81c906001016000526002026020015160f01c565b73ffffffffffffffffffffffffffffffffffffffff1661034001a4600051803560f81c906001016000526002026020015160f01c565b9073ffffffffffffffffffffffffffffffffffffffff166103400190f0600051803560f81c906001016000526002026020015160f01c565b9273ffffffffffffffffffffffffffffffffffffffff1661034001929473ffffffffffffffffffffffffffffffffffffffff166103400194f1600051803560f81c906001016000526002026020015160f01c565b60006000fd5b73ffffffffffffffffffffffffffffffffffffffff1661034001f35b9173ffffffffffffffffffffffffffffffffffffffff1661034001919373ffffffffffffffffffffffffffffffffffffffff166103400193f4600051803560f81c906001016000526002026020015160f01c565b60006000fd5b9073ffffffffffffffffffffffffffffffffffffffff166103400190f5600051803560f81c906001016000526002026020015160f01c565b9173ffffffffffffffffffffffffffffffffffffffff1661034001919373ffffffffffffffffffffffffffffffffffffffff166103400193fa600051803560f81c906001016000526002026020015160f01c565b73ffffffffffffffffffffffffffffffffffffffff1661034001fd600051803560f81c906001016000526002026020015160f01c565bfe600051803560f81c906001016000526002026020015160f01c565b60006000fd5b60006000fd00560072008e00aa00c600e200fe011a01360152016e018a14d714d714d714d701a601c201de01fa02160232024e026a028602a202be02da02f6031214d714d7032e14d714d714d714d714d714d714d714d714d714d714d714d714d714d714d703640380039c03b803d403f0041204360474049004c604e204fe05360552058805a405c005dc05f806140630064c0668068414d714d714d714d714d714d714d706a006bc06f20728075e077a079607cb07ec080d0846086214d714d714d714d7087d08ac08db090a09390968099709c609f50a240a530a820ab10ae00b0f0b3e0b6d0b9c0bcb0bfa0c290c580c870cb60ce50d140d430d720da10dd00dff0e2e0e5d0e790e950eb10ecd0ee90f050f210f3d0f590f750f910fad0fc90fe51001101d103910551071108d10a910c510e110fd111911351151116d118911a511c111dd12131249127f12b514d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d714d712eb13231377137d139913f314d714d714d714d7142b14d714d7147f14b514d1";
