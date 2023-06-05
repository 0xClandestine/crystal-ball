// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "solady/Milady.sol";

contract CompressedTokenUri {
    function tokenURI(uint256 id)
        external
        view
        virtual
        returns (string memory)
    {}
}

abstract contract CompressedERC721 is ERC721 {
    address private immutable vevm;

    address private immutable flzCompressedTokenUriBytecodePointer;

    constructor(address _vevm, bytes memory _flzCompressedTokenUriBytecode) {
        vevm = _vevm;
        flzCompressedTokenUriBytecodePointer =
            SSTORE2.write(_flzCompressedTokenUriBytecode);
    }

    function tokenURI(uint256 id)
        public
        view
        virtual
        override
        returns (string memory)
    {
        bytes memory tokenUriBytecode = LibZip.flzDecompress(
            SSTORE2.read(flzCompressedTokenUriBytecodePointer)
        );

        (, bytes memory returnData) = vevm.staticcall(
            abi.encodePacked(
                // runtime
                tokenUriBytecode,
                // calldata
                this.tokenURI.selector,
                id,
                // runtimeLength (needed for calldata support)
                tokenUriBytecode.length
            )
        );

        return abi.decode(returnData, (string));
    }
}
