import { useEffect, useState } from "react";

export default function useConfig() {
  const [config, setConfig] = useState({
    CONTRACT_ADDRESS: "0x51b449D8bc3b46D7b897B5fD0211eAe48c9D7FCA",
    SCAN_LINK: "https://blockexplorer.boba.network/address",
    SCAN_LINK_BOBA: "https://blockexplorer.boba.network/address",
    SCAN_LINK_BOBA_RINKEBY: "https://blockexplorer.rinkeby.boba.network/address",
    SCAN_LINK_RINKEBY: "https://rinkeby.etherscan.io/token",
    NETWORK: {
      NAME: "Boba Network",
      SYMBOL: "ETH",
      ID: 288,
    },
    NFT_NAME: "GhostNColors",
    SYMBOL: "GNC",
    WEI_COST: 15000000000000000000,
    DISPLAY_COST: 0.0015,
    GAS_LIMIT: 38500000,

    MARKETPLACE_BOBA: "ShibuiNFT",
    MARKETPLACE_LINK: "https://shibuinft.com/app/collection",

    MARKETPLACE_BOBA_RINKEBY: "ShibuiNFT",
    MARKETPLACE_LINK_BOBA_RINKEBY: "https://shibuinft.com/app/collection",

    MARKETPLACE_RINKEBY: "Rarible",
    MARKETPLACE_LINK_RINKEBY: "https://rinkeby.rarible.com/collection",
    SHOW_BACKGROUND: true,
    RINKEBY : "0x7a5c440a8bf560e61bb37548dc9b137828b16b70",
    RINKEBY_BOBA: "0xb4e79dB81A97C09B52278AdF9757393e80451d5C"
  });

  return config
}
