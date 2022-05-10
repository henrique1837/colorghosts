// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "base64-sol/base64.sol";

interface Helper {
  function TuringRandom() external returns (uint256);
}

/**
 * @title Bobaboltz
 * Modified from https://github.com/omgnetwork/optimism-v2/blob/develop/boba_community/turing-monsters/contracts/ERC721min.sol;
 * Merged with https://github.com/HashLips/solidity_smart_contracts/blob/main/contracts/NFT/NFT.sol;
 * Included royalties fees https://docs.openzeppelin.com/contracts/4.x/api/token/erc721#ERC721Royalty;
 */
contract ColorGhosts is ERC721Enumerable,ERC721Royalty,Pausable,Ownable {

    uint256 public cost = 0.0015 ether;
    uint256 public maxSupply = 10000;
    uint256 public maxMintAmount = 5;
    uint256 internal fee;
    /// @dev Required by EIP-2981: NFT Royalty Standard
    address private _receiver;
    uint96 private _feeNumerator;
    // Optional mapping for token URIs
    mapping(uint256 => uint256) private _tokenURIs;
    mapping(uint256 => uint256) private _tokenGenomes;

    address public helperAddr;
    Helper helper;

    string public external_url;

    using SafeMath for uint256;

    constructor(
      string memory name,
      string memory symbol,
      address _helper) ERC721(name, symbol) {
        helperAddr = _helper;
        helper = Helper(helperAddr);
        /// @dev Set default royalties for EIP-2981
        _setDefaultRoyalty(owner(), 100);
    }


    /// Check interface support.
    /// @param interfaceId the interface id to check support for
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721Enumerable, ERC721Royalty)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function baseURI() public view returns (string memory) {
        return _baseURI();
    }

    function exists(uint256 tokenId) public view returns (bool) {
        return _exists(tokenId);
    }

    function mint(uint256 _mintAmount) external payable whenNotPaused {
      uint256 supply = totalSupply();
      require(_mintAmount > 0, "need to mint at least 1 NFT");
      require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
      require(supply.add(_mintAmount) <= maxSupply, "max NFT limit exceeded");

      if (msg.sender != owner()) {
          require(msg.value >= cost.mul(_mintAmount), "insufficient funds");
      }

      (bool success, ) = payable(owner()).call{value: msg.value}("");
      require(success);

      uint256 turingRAND = helper.TuringRandom();
      for(uint256 i = 1; i <= _mintAmount; i++){
        uint256 tokenId = supply.add(i);
        _mint(msg.sender, tokenId);
        _tokenGenomes[tokenId] = turingRAND.div(i);
        _setTokenURI(tokenId, turingRAND.div(i));
      }



    }


    function _setTokenURI(uint256 tokenId, uint256 _tokenURI) internal virtual {
        require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }

    function getSVG(uint tokenId) private view returns (string memory) {

        require(_exists(tokenId), "ERC721getSVG: URI get of nonexistent token");

        uint256 genome = _tokenURIs[tokenId];
        bytes memory i_bytes = abi.encodePacked(genome);
        uint8 attribute_a = uint8(i_bytes[0]);
        uint8 attribute_b = uint8(i_bytes[1]);
        uint8 attribute_c = uint8(i_bytes[2]);
        uint8 attribute_d = uint8(i_bytes[3]);
        uint8 attribute_e = uint8(i_bytes[4]);

        string[5] memory part;

        string memory colorBody1  = string(abi.encodePacked(Strings.toString(attribute_c), ",", Strings.toString(attribute_b), ",", Strings.toString(attribute_e)));
        string memory colorBody2  = string(abi.encodePacked(Strings.toString(attribute_e), ",", Strings.toString(attribute_c), ",", Strings.toString(attribute_d)));
        string memory colorBody3  = string(abi.encodePacked(Strings.toString(attribute_b), ",", Strings.toString(attribute_d), ",", Strings.toString(attribute_c)));
        string memory colorBody4  = string(abi.encodePacked(Strings.toString(attribute_d), ",", Strings.toString(attribute_e), ",", Strings.toString(attribute_a)));

        part[0] = "<svg id='a' xmlns='http://www.w3.org/2000/svg' viewBox='0 0 111.99 69.19'><defs><style>.c{fill:rgb(";
        part[1] = ")}.d{fill:rgb(";
        part[2] = ")}.e,g{fill:rgb(";
        part[3] = ")}.h{fill:rgb(";
        part[4] = ")}.i{fill:rgb(141, 199, 63);}.k{fill:none;}.l{fill:rgb(30, 30, 30);}</style></defs><path class='d' d='M101.41,46.9c-.42,9.59-3.71,22.26-3.71,22.26-1.41-.67-2.54-1.3-3.73-1.77-.52-.2-1.03-.32-1.54-.4-.35-.06-.7-.09-1.04-.1-1.75-.04-3.46,.51-5.16,1.29-3.36,1.54-6.56,1.45-9.44-1.2-1.74-1.6-3.65-2.05-5.78-1.93-.94,.05-2.05,.45-2.05,.45-3.65,1.18-7.24-.47-8.95-3.86,0,0-.51,0,1.45-2.4,0,0,20.01,5.31,39.95-12.35Z'/><path class='h' d='M101.46,41.69c0,1.74,0,3.47-.05,5.2-3.52,3.25-7.81,6.16-12.71,8.45-9.53,4.45-19.38,5.63-27.24,3.9,0,0,2.36-2.97,2.8-3.66,1.95-3.05,2.69-6.55,2.89-10.12,0,0,.44-8.17,.36-8.97,13.76-2.5,29.1-15.92,29.1-15.92,0,0,4.8,7.17,4.85,21.12Z'/><path class='k' d='M80.43,30.63c-.33,.37-.39,.79-.24,1.2,.76-.39,1.5-.79,2.23-1.2-.03-.02-.05-.03-.08-.05-.68-.52-1.42-.51-1.91,.05Z'/><path class='c' d='M67.51,36.49c13.96-2.5,29.1-15.92,29.1-15.92-4.73-7.31-10.48-7.22-14.76-6.68-5.69,.72-10.56,4.59-12.64,9.93,0,0-1.7,4.55-1.7,12.67'/><path class='i' d='M94.97,27.74c-.2,.05-.39,.14-.54,.28l.54-.28Z'/><path class='k' d='M72.76,28.7c-.7,.04-1.17,.55-1.19,1.3,0,.34,.03,.68,.04,1.02h0c.02,.37,0,.74,.06,1.11,.1,.72,.55,1.12,1.27,1.12,.73,0,1.21-.43,1.26-1.14,.05-.79,.02-1.6-.1-2.38-.11-.7-.61-1.08-1.35-1.04Z'/><g><path class='l' d='M72.75,28.98c-.7,.06-1.15,.59-1.14,1.35,0,.34,.05,.68,.08,1.02h0c.03,.37,.03,.74,.1,1.1,.13,.72,.59,1.1,1.31,1.07,.73-.03,1.2-.48,1.22-1.18,.02-.79-.04-1.6-.19-2.37-.13-.69-.65-1.05-1.38-.99Z'/><path class='l' d='M87.86,30.01c-.55-.48-1.28-.4-1.9,.21-1.14,1.14-2.24,1.22-3.57,.28-.7-.5-1.44-.45-1.9,.12-.49,.6-.4,1.29,.26,1.88,.59,.53,1.25,.86,1.96,1.05,.18,.05,.37,.09,.56,.12,.38,.06,.77,.08,1.17,.06,1.36-.17,2.53-.7,3.42-1.76,.31-.37,.46-.75,.44-1.1,0-.13-.04-.26-.09-.38-.08-.17-.19-.34-.36-.48Z'/><path class='l' d='M96.66,29.34c-.03-.37-.04-.74-.1-1.1-.12-.72-.55-1.11-1.29-1.11-.13,0-.25,.02-.37,.05-.2,.06-.39,.16-.53,.3-.23,.22-.37,.53-.36,.89,0,.77,.05,1.54,.19,2.29,.13,.7,.63,1.07,1.36,1.03,.7-.04,1.17-.58,1.17-1.32,0-.34-.05-.68-.08-1.02Z'/></g><g><path class='d' d='M52.11,22.67c-.04-3.04-.21-6.09-.65-9.07-.09-.64-.23-1.27-.39-1.88h0c-.8-3.15-2.41-5.84-4.7-7.85h0c-.66-.58-1.38-1.12-2.15-1.58l-.03-.02c-1.64-.97-3.52-1.65-5.62-1.99-3.91-.62-7.63-.35-11.03,1.88-2.87,1.89-4.67,4.57-5.91,7.61,3.41,2.53,7.28,5.12,11.7,7.18,6.46,3.01,13.17,4.47,18.79,5.71Z'/><path class='c' d='M19.63,37.84c1.21,10.06,3.43,15.93,3.43,15.93,.33-.17,.46-.23,.58-.31,3.06-2.08,6.24-2.59,9.7-.92l2.57,.92c2.64,.62,5.17,.08,7.54-2.13,1.87-1.75,4.17-2.23,6.75-1.61,0,0,7.4,1.11,9.31-3.79,0,0-1.67-1.53-3.34-4.19'/><path class='c' d='M19.63,37.84c1.18,.67,2.4,1.3,3.67,1.9,11.98,5.59,24.46,6.03,32.87,2.01'/><path class='g' d='M53.5,36.12c.6,1.98,1.51,3.85,2.67,5.63-8.4,4.02-20.89,3.58-32.87-2.01-1.27-.59-2.48-1.23-3.67-1.9-.04-.3-.08-.59-.13-.89-.62-4.25-.65-8.88-.65-8.88,0-.13-.47-6.21,1.24-13.53v-.04c.27-1.06,.57-2.11,.92-3.15,.18-.54,.38-1.06,.6-1.58,3.41,2.53,7.28,5.12,11.7,7.18,6.46,3.01,13.17,4.47,18.79,5.71,0,0,.03,8.95,1.39,13.44Z'/></g><g><path class='l' d='M26.56,11.74c-1.74-.05-3.31,1.4-3.32,3.07,0,.84,.68,1.39,1.44,1.15,.5-.16,.66-.56,.77-1.05,.17-.82,.87-1.17,1.51-.83,.41,.22,.49,.61,.56,1.04,.12,.72,.61,1.1,1.26,1,.58-.08,.96-.6,.93-1.27-.07-1.69-1.46-3.07-3.14-3.12Z'/><path class='l' d='M37.36,17.14c-1.09,.85-1.83,.82-2.88-.12-.23-.2-.46-.3-.68-.35-.64-.12-1,.41-1,.41-.34,.43-.31,1.01,.14,1.5,.75,.82,1.68,1.28,2.8,1.33,1.2,.07,2.24-.31,3.1-1.14,.51-.5,.56-1.15,.14-1.62-.43-.48-1.02-.49-1.61-.03Z'/><path class='l' d='M48.75,15.44c-.1-1.64-1.51-2.99-3.16-3.03-1.58-.03-2.93,1.07-3.25,2.66-.16,.81,.14,1.41,.78,1.56,.67,.15,1.18-.21,1.37-1.04,.14-.6,.45-.97,1.08-.94,.65,.03,.89,.47,.99,1.06,.13,.81,.55,1.18,1.23,1.11,.65-.07,1.01-.59,.96-1.38Z'/></g></svg>";

        return string(abi.encodePacked(
          part[0],
          colorBody1,
          part[1],
          colorBody2,
          part[2],
          colorBody3,
          part[3],
          colorBody4,
          part[4]
        ));
    }

    function tokenURI(uint256 tokenId) override public view returns (string memory) {
      string memory svgData = getSVG(tokenId);
      bytes memory i_bytes = abi.encodePacked(_tokenGenomes[tokenId]);
      string memory velocity = Strings.toString(uint8(i_bytes[5]));
      string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "#',Strings.toString(tokenId),'", "description": "Color Ghosts", "external_url":"',external_url,'" , "image_data": "', bytes(svgData), '", "attributes" : [{"trait_type" : "genome","value" : "',Strings.toString(_tokenGenomes[tokenId]),'"},{"trait_type" : "velocity","value" : "',velocity,'"}]}'))));
      return string(abi.encodePacked('data:application/json;base64,', json));
    }


    // From https://github.com/vzoo/ERC721-with-EIP2981-Polygon-bulk-mint-OpenSea-compatible/blob/main/contracts/VZOOERC721.sol
    /// Sets the default royalty address and fee
    /// @dev feeNumerator defaults to 1000 = 10% of transaction value
    /// @param receiver wallet address of new receiver
    /// @param feeNumerator new fee numerator
    function setDefaultRoyalty(address receiver, uint96 feeNumerator)
        external
        onlyOwner {
        _setDefaultRoyalty(receiver, feeNumerator);
    }

    function setExternalURL(string memory url)
        external
        onlyOwner {
        external_url = url;
    }

    function withdraw() public payable onlyOwner {
      (bool sent, ) = payable(owner()).call{value: address(this).balance}("");
      require(sent);
    }

    // Pauses the contract
    function pause() external onlyOwner {
        _pause();
    }

    // Unpauses the contract
    function unpause() external onlyOwner {
        _unpause();
    }


    /// @param from wallet address to send the NFT from
    /// @param to wallet address to send the NFT to
    /// @param tokenId NFT id to transfer
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    /// @dev Required override to comply with EIP-2981
    /// @param tokenId the NFT id to burn royalty information for
    function _burn(uint256 tokenId)
        internal
        virtual
        override(ERC721, ERC721Royalty)
    {
        super._burn(tokenId);
    }

}
