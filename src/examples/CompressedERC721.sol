// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// import "solady/Milady.sol";
// import "../Magic.sol";

// contract CompressedTokenUri {
//     function uri(uint256 id) external view returns (string memory) {}
// }

// abstract contract CompressedERC721 is ERC721 {
//     using Magic for CrystalBall;

//     address private immutable crystalBall;

//     bytes private immutable flzCompressedTokenUriBytecode;

//     constructor(
//         address _crystalBall,
//         bytes memory _flzCompressedTokenUriBytecode
//     ) {
//         crystalBall = _crystalBall;
//         flzCompressedTokenUriBytecode = _flzCompressedTokenUriBytecode;
//     }

//     function uri(uint256 id)
//         external
//         view
//         virtual
//         override
//         returns (string memory)
//     {
//         bytes memory tokenUriBytecode =
//             LibZip.flzDecompress(flzCompressedTokenUriBytecode);

//         return abi.decode(
//             crystalBall.staticcall(
//                 abi.encodePacked(
//                     tokenUriBytecode, bytes4(0), id, tokenUriBytecode.length
//                 )
//             ),
//             (string)
//         );
//     }
// }
