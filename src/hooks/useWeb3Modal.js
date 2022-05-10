import { useCallback,useMemo, useState } from "react";
import { ethers } from "ethers";
import Web3Modal from "web3modal";
import WalletConnectProvider from "@walletconnect/web3-provider";

const providerOptions = {

  // Currently the package isn't inside the web3modal library currently. For now,
  // users must use this libary to create a custom web3modal provider.

  // All custom `web3modal` providers must be registered using the "custom-"
  // prefix.
  walletconnect: {
    package: WalletConnectProvider, // required
    options: {
      rpc:{
        288: "https://mainnet.boba.network",
        28: "https://rinkeby.boba.network/",
        4: "https://rinkeby.infura.io/v3/7c611c436e1a448bbd57b70cdbe9a5c0"
      }
    }
  }


};


const web3Modal = new Web3Modal({
  cacheProvider: true,
  providerOptions
});

function useWeb3Modal(config = {}) {
  const [provider, setProvider] = useState();
  const [coinbase, setCoinbase] = useState();
  const [netId , setNetId] = useState();
  const [connecting , setConnecting] = useState();
  const [noProvider , setNoProvider] = useState();
  const [err , setErr] = useState();

  //const [cyberConnect , setCyberConnect] = useState();

  const [autoLoaded, setAutoLoaded] = useState(false);
  // Web3Modal also supports many other wallets.
  // You can see other options at https://github.com/Web3Modal/web3modal
  const logoutOfWeb3Modal = useCallback(
    async function () {
      await web3Modal.clearCachedProvider();
      setCoinbase();
      setNetId(288);
      setProvider(new ethers.providers.JsonRpcProvider("https://mainnet.boba.network"));
    },
    [],
  );
  // Open wallet selection modal.
  const loadWeb3Modal = useCallback(async () => {

    try{
      setErr()
      setConnecting(true);
      setAutoLoaded(true);
      const conn = await web3Modal.connect();
      const newProvider = new ethers.providers.Web3Provider(conn,"any");
      const signer = newProvider.getSigner()
      const newCoinbase = await signer.getAddress();
      const {chainId} = await newProvider.getNetwork();
      setProvider(newProvider);
      setCoinbase(newCoinbase);
      setNetId(chainId);
      setNoProvider(true);
      setConnecting(false);

      conn.on('accountsChanged', accounts => {
        const newProvider = new ethers.providers.Web3Provider(conn,"any");
        setProvider(newProvider)
        setCoinbase(accounts[0]);
        window.location.reload();
      });
      conn.on('chainChanged', async chainId => {
        window.location.reload();
      });
      // Subscribe to provider disconnection
      conn.on("disconnect", async (error: { code: number; message: string }) => {
        logoutOfWeb3Modal();
        window.location.reload();

      });
      conn.on("close", async () => {
        logoutOfWeb3Modal();
      });

      return;
    } catch(err){
      console.log(err);
      setConnecting(false)
      setErr(err);
      logoutOfWeb3Modal();
    }

  }, [logoutOfWeb3Modal]);




  // If autoLoad is enabled and the the wallet had been loaded before, load it automatically now.
  useMemo(() => {
    if (!autoLoaded && web3Modal.cachedProvider) {
      setAutoLoaded(true);
      loadWeb3Modal();
      setNoProvider(true);
    }
  },[autoLoaded,loadWeb3Modal]);

  useMemo(() => {

    if(!noProvider && !autoLoaded && !web3Modal.cachedProvider && !connecting){
      setProvider(new ethers.providers.JsonRpcProvider("https://mainnet.boba.network"));
      setNetId(288);
      setNoProvider(true);
      setAutoLoaded(true);
    }



  },[
    noProvider,
    autoLoaded,
    connecting
   ]);


  return({provider, loadWeb3Modal, logoutOfWeb3Modal,coinbase,netId,connecting,err});
}



export default useWeb3Modal;
