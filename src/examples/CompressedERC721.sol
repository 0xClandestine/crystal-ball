// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "solady/Milady.sol";
import "../Magic.sol";

contract CompressedTokenUri {
    function tokenURI(uint256 id)
        external
        view
        virtual
        returns (string memory)
    {}
}

abstract contract CompressedERC721 is ERC721 {
    using Magic for CrystalBall;

    CrystalBall private immutable vevm;

    address private immutable flzCompressedTokenUriBytecodePointer;

    constructor(
        CrystalBall _vevm,
        bytes memory _flzCompressedTokenUriBytecode
    ) {
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

        return abi.decode(
            vevm.staticcall(
                tokenUriBytecode, abi.encodePacked(this.tokenURI.selector, id)
            ),
            (string)
        );
    }
}
