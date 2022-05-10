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
 * @title GhostNColors
 * Modified from https://github.com/omgnetwork/optimism-v2/blob/develop/boba_community/turing-monsters/contracts/ERC721min.sol;
 * Merged with https://github.com/HashLips/solidity_smart_contracts/blob/main/contracts/NFT/NFT.sol;
 * Included royalties fees https://docs.openzeppelin.com/contracts/4.x/api/token/erc721#ERC721Royalty;
 */
contract GhostNColors is ERC721Enumerable,ERC721Royalty,Pausable,Ownable {

    uint256 public cost = 0.0015 ether;
    uint256 public maxSupply = 10000;
    uint256 public maxMintAmount = 5;
    uint256 internal fee;
    /// @dev Required by EIP-2981: NFT Royalty Standard
    address private _receiver;
    uint96 private _feeNumerator;
    // Optional mapping for token URIs
    mapping(uint256 => uint256) private _tokenURIs;

    string public external_url;
    address public helperAddr;
    Helper helper;

    using SafeMath for uint256;
    using SafeMath for uint8;

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
        _setTokenURI(tokenId, turingRAND.div(i));
      }



    }


    function _setTokenURI(uint256 tokenId, uint256 _tokenURI) internal virtual {
        require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }

    function _getColors(uint genome) private view returns(string[3] memory){
        bytes memory i_bytes = abi.encodePacked(genome);
        uint8 attribute_a = uint8(i_bytes[0]);
        uint8 attribute_b = uint8(i_bytes[1]);
        uint8 attribute_c = uint8(i_bytes[2]);
        uint8 attribute_d = uint8(i_bytes[3]);
        uint8 attribute_e = uint8(i_bytes[4]);

        string memory colorBody1  = string(abi.encodePacked(Strings.toString(attribute_c), ",", Strings.toString(attribute_b), ",", Strings.toString(attribute_e)));
        string memory colorBody2  = string(abi.encodePacked(Strings.toString(attribute_e), ",", Strings.toString(attribute_c), ",", Strings.toString(attribute_d)));
        string memory colorBody3  = string(abi.encodePacked(Strings.toString(attribute_b), ",", Strings.toString(attribute_d), ",", Strings.toString(attribute_c)));

        return([
            colorBody1,
            colorBody2,
            colorBody3
        ]);
    }

    function getSVG(uint tokenId) private view returns (string memory) {

        require(_exists(tokenId), "ERC721getSVG: URI get of nonexistent token");

        uint256 genome = _tokenURIs[tokenId];
        string[3] memory colorBody = _getColors(genome);
        string[4] memory part;

        part[0] = "<svg id='a' xmlns='http://www.w3.org/2000/svg' viewBox='0 0 82.66364 69.18715'>";
        part[1] = string(
                    abi.encodePacked("<defs><linearGradient id='g' x1='0' x2='1' y1='0' y2='1' spreadMethod='pad'><stop offset='0%' stop-color='rgb(",
                                    colorBody[0],
                                    ")'/> <stop offset='50%' stop-color='rgb(",
                                     colorBody[1],
                                    ")'/> <stop offset='100%' stop-color='rgb(",
                                    colorBody[2],
                                    ")'/></linearGradient></defs>")
                  );
        part[2] = "<path fill='url(#g)' d='M77.81066,20.57252c-4.73102-7.31476-10.47852-7.22314-14.76355-6.68402-5.68622,.71539-10.56311,4.58545-12.64001,9.92694,0,0-1.69928,4.5517-1.69928,12.67218l-.00049,.00061c.08868,.80865-.35535,8.97479-.35535,8.97479-.20618,3.57214-.94122,7.07562-2.89325,10.12445-.44116,.68915-2.80096,3.65936-2.80096,3.65936-1.95074,2.40143-1.44519,2.40125-1.44519,2.40125,1.70532,3.39105,5.30042,5.03296,8.94562,3.85742,0,0,1.10846-.39777,2.04614-.45068,2.13519-.12042,4.04224,.32489,5.78485,1.92523,2.88287,2.64734,6.08636,2.73926,9.44452,1.19647,1.69733-.77985,3.40063-1.32483,5.15533-1.2865,.34442,.00751,.69116,.04047,1.04004,.09692,.50696,.08209,1.0174,.20166,1.53564,.40198,1.19617,.46234,2.32666,1.09442,3.73254,1.76691,0,0,3.29175-12.6637,3.71124-22.25745,.05402-1.7326,.05951-3.4668,.05292-5.2049-.05292-13.95416-4.85077-21.12097-4.85077-21.12097ZM42.66991,59.24915 M37.36382,41.74622c-1.15515-1.78168-2.06683-3.65051-2.66608-5.63068-1.36127-4.49841-1.39172-13.44373-1.39172-13.44373-.04315-3.04016-.21356-6.08557-.65472-9.07495-.09491-.64276-.2312-1.26526-.38751-1.87677l-.00281-.01111c-.80389-3.1366-2.41217-5.82666-4.69861-7.83496l-.00043-.00031c-.66394-.58313-1.3772-1.11676-2.1543-1.57727l-.03265-.01868c-1.63953-.96588-3.51544-1.65417-5.61743-1.98828C15.85216-.33129,12.12767-.06243,8.73076,2.17268c-2.8728,1.8902-4.6665,4.56702-5.91321,7.60718-.21228,.51758-.41351,1.04248-.59637,1.57922-.35498,1.04199-.64844,2.09338-.91058,3.14935l-.01019,.04041C-.40522,21.86774,.05541,27.94263,.05999,28.07502c0,0,.0249,4.62347,.64539,8.87573,.04327,.29669,.08557,.59369,.12714,.89069,1.20654,10.05896,3.42865,15.93073,3.42865,15.93073,.32788-.17303,.46222-.22839,.57977-.30829,3.06433-2.08386,6.23596-2.59381,9.69861-.92169l2.56757,.9234c2.64117,.62006,5.16541,.08459,7.53949-2.1333,1.8689-1.74597,4.17108-2.22589,6.75201-1.60675,0,0,7.39642,1.11432,9.30823-3.79395,0,0-1.67407-1.52789-3.34302-4.18536Z'/>";
        part[3] = "<g><path fill='rgb(30,30,30)' d='M53.9535,28.98283c-.69844,.06283-1.14685,.59441-1.13563,1.34776,.00515,.34038,.05213,.68016,.08011,1.02016l.00451-.00029c.03034,.36832,.0318,.74188,.09708,1.10394,.12919,.71695,.58719,1.10296,1.31348,1.07383,.7322-.02941,1.19562-.47868,1.21618-1.1846,.02305-.79043-.04328-1.59771-.19201-2.37445-.13229-.69063-.64656-1.05271-1.38372-.98634Z M69.05639,30.00637c-.5529-.47771-1.2834-.3951-1.89518,.21435-1.14074,1.13631-2.23936,1.2239-3.56573,.28432-.70351-.49847-1.43687-.45289-1.90205,.11817-.48509,.59538-.39694,1.29135,.26498,1.8772,.59431,.52611,1.25423,.86009,1.96136,1.04674,.18471,.04879,.37248,.088,.56363,.11651,.37905,.05642,.76873,.07903,1.16995,.06272,1.36399-.17023,2.52801-.70146,3.41566-1.75633,.31396-.37319,.45561-.75155,.43723-1.10249-.00691-.13136-.03748-.25835-.09033-.37998-.07526-.17343-.19191-.33644-.35954-.48122Z M77.86501,29.3443c-.03027-.36832-.03627-.74068-.09611-1.10422-.11772-.71561-.55423-1.10512-1.28719-1.10707-.12791-.0003-.24885,.02216-.36514,.05471-.20235,.05669-.38535,.15509-.53038,.29524-.22664,.21903-.36624,.52719-.36448,.88584,.00372,.76511,.05491,1.54022,.1923,2.2915,.12715,.69528,.63009,1.06775,1.36132,1.02725,.69606-.03862,1.17105-.58103,1.16899-1.32318-.00099-.34011-.05139-.68006-.07931-1.02007Z M7.76502,11.7419c-1.73989-.04767-3.30889,1.40357-3.32286,3.07342-.00697,.83854,.68131,1.3924,1.43864,1.14685,.50055-.16235,.66334-.56031,.76648-1.04552,.17374-.81767,.86553-1.17469,1.50948-.82619,.41048,.22214,.48869,.61414,.55774,1.03633,.11838,.72432,.61246,1.0963,1.25779,1.00412,.58456-.08351,.9621-.59735,.93379-1.27112-.07103-1.68956-1.46366-3.07196-3.14105-3.11788Z M18.56558,17.13601c-1.08712,.84844-1.82901,.81736-2.88369-.12092-.22603-.20109-.4574-.30242-.68472-.34558-.63683-.1174-1.00262,.41263-1.00262,.41263-.33585,.43434-.30587,1.01131,.14376,1.50287,.75032,.82015,1.68217,1.27684,2.79991,1.33356,1.19922,.07229,2.23598-.31152,3.09725-1.14201,.51476-.49639,.55719-1.15348,.14111-1.61511-.43375-.4811-1.01543-.49031-1.61101-.02543Z M29.95324,15.4439c-.10261-1.64151-1.51091-2.9932-3.15519-3.02833-1.58272-.03382-2.92961,1.07012-3.24935,2.66323-.16251,.80963,.13904,1.41175,.78049,1.55873,.67272,.15413,1.18072-.20717,1.36773-1.03829,.13583-.60389,.44588-.97128,1.08405-.9387,.64755,.03309,.89479,.47216,.98661,1.0591,.12683,.81158,.5518,1.18262,1.22537,1.10709,.64978-.07284,1.00974-.59128,.96029-1.38283Z'/></g></svg>";

        return string(abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(
                    bytes(abi.encodePacked(
                            part[0],
                            part[1],
                            part[2],
                            part[3]
                    ))

            ))
        );
    }

    function tokenURI(uint256 tokenId) override public view returns (string memory) {
      string memory svgData = getSVG(tokenId);
      uint256 genome = _tokenURIs[tokenId];
      bytes memory i_bytes = abi.encodePacked(genome);
      string[3] memory colors = _getColors(genome);
      string memory velocity = Strings.toString(uint8(i_bytes[5]));
      string memory attributes = string(
          abi.encodePacked(
              '"attributes" : [{"trait_type" : "genome","value" : "',
              Strings.toString(genome),
              '"},{"trait_type" : "velocity","value" : "',
              velocity,
              '"},{"trait_type" : "color1","value" : "',
              colors[0],
              '"},{"trait_type" : "color2","value" : "',
              colors[1],
              '"},{"trait_type" : "color3","value" : "',
              colors[2],
              '"}]'
          )
      );
      string memory json = Base64.encode(
        bytes(
          string(
              abi.encodePacked(
                  '{"name": "#',
                  Strings.toString(tokenId),
                  '", "description": "Color Ghosts", "external_url":"',
                  external_url,
                  '","image_data":"',
                  bytes(svgData),
                  '",',
                  attributes,
                  '}')
          )
        )
      );
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
