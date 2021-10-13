// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;


// We need some util functions for strings.
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import { Base64 } from "./libraries/Base64.sol";


contract MyEpicNFT is ERC721URIStorage {

  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  uint256 public constant maxSupply = 20;

  string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='purple' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

  string[] firstWords = ["Unicorn", "Pug", "BradPitt", "SnoopDog", "Buildspace", "Edatweets", "KanyeWest", "Oprah", "Britney"];
  string[] secondWords = ["Carbonara", "GinTonic", "Champagne", "ClubSandwich", "McNugges", "IceCream", "Oatmeal", "Pizza"];

  constructor() ERC721 ("Eda's Collection", "SQUARE") {
    console.log("This is my NFT contract. Woah!");
  }
  
  function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    rand = rand % firstWords.length;
    return firstWords[rand];
  }
    function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    rand = rand % secondWords.length;
    return secondWords[rand];
  }

  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

  event NewEpicNFTMinted(address sender, uint256 tokenId);

  function getTotalNFTsMintedSoFar() public view returns (uint256){
    uint256 newItemId = _tokenIds.current();
    return newItemId;
  }

  function makeAnEpicNFT() public {
    uint256 newItemId = _tokenIds.current();
    require(newItemId < maxSupply);

    string memory first = pickRandomFirstWord(newItemId);
    string memory second = pickRandomSecondWord(newItemId);
    string memory finalSvg = string(abi.encodePacked(baseSvg, first, second, "</text></svg>"));
    string memory combinedWord = string(abi.encodePacked(first, second));
    // Get all the JSON metadata in place and base64 encode it.
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    combinedWord,
                    '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );

    // Just like before, we prepend data:application/json;base64, to our data.
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    _safeMint(msg.sender, newItemId);
    
    _setTokenURI(newItemId, finalTokenUri);
  
    _tokenIds.increment();
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    emit NewEpicNFTMinted(msg.sender, newItemId);

  }
}