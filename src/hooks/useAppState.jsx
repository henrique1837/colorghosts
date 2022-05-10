import React,{ useState,useMemo,useContext } from 'react'




/**
 * Our custom React hook to manage state
 */

 const AppContext = React.createContext({})



const useAppState = () => {
  const initialState = {
    provider: null,
    netId: null,
    coinbase: null,
    contract: null,
    totalSupply: 0,
    maxSupply: 0,
    loadWeb3Modal: null,
    cost: null,
    nfts: [],
    myNfts: []
  }

  // Manage the state using React.useState()
  const [state, setState] = useState(initialState)

  // Build our actions. We'll use useMemo() as an optimization,
  // so this will only ever be called once.
  const actions = useMemo(() => getActions(setState), [setState])

  return { state, actions }
}

// Define your actions as functions that call setState().
// It's a bit like Redux's dispatch(), but as individual
// functions.
const getActions = (setState) => ({
  setProvider: (provider) => {
    setState((state) => ({ ...state, provider: provider }))
  },
  setNetId: (netId) => {
    setState((state) => ({ ...state, netId: netId }))
  },
  setLoadWeb3Modal: (loadWeb3Modal) => {
    setState((state) => ({ ...state, loadWeb3Modal: loadWeb3Modal }))
  },
  setCost: (cost) => {
    setState((state) => ({ ...state, cost: cost }))
  },
  setCoinbase: (coinbase) => {
    setState((state) => ({ ...state, coinbase: coinbase }))
  },
  setContract: (contract) => {
    setState((state) => ({ ...state, contract: contract }))
  },
  setTotalSupply: (totalSupply) => {
    setState((state) => ({ ...state, totalSupply: totalSupply }))
  },
  setMaxSupply: (maxSupply) => {
    setState((state) => ({ ...state, maxSupply: maxSupply }))
  },
  setNFTs: (nfts) => {
    setState((state) => ({ ...state, nfts: nfts }))
  },
  setMyNFTs: (myNfts) => {
    setState((state) => ({ ...state, myNfts: myNfts }))
  }
})


const useAppContext = () => {
  return useContext(AppContext)
}

export { AppContext, useAppState, useAppContext }
