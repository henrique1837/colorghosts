import { useState } from "react";

// Enter a valid infura key here to avoid being rate limited
// You can get a key for free at https://infura.io/register
import { ApolloClient, InMemoryCache,gql } from '@apollo/client';
import useConfig from "../hooks/config";
import { addresses, abis } from "../contracts";

const APIURL_BOBA = "https://api.thegraph.com/subgraphs/name/quantumlyy/eip721-subgraph-boba";
const APIURL_RINKEBY_BOBA = "https://api.thegraph.com/subgraphs/name/quantumlyy/eip721-subgraph-boba";

function useGraphClient() {
  const CONFIG = useConfig()

  const [client,setClient] = useState();
  const [contractAddress,setContractAddress] = useState();
  const initiateClient = (netId) => {
    //if(!client && netId){
     let newClient;
     let newContractAddress;

     if(netId === 28){
       newClient = new ApolloClient({
         uri: APIURL_RINKEBY_BOBA,
         cache: new InMemoryCache()
       });
       newContractAddress = addresses.nft.rinkeby_boba
     } else {
       newClient = new ApolloClient({
         uri: APIURL_BOBA,
         cache: new InMemoryCache()
       });
       newContractAddress = addresses.nft.boba
     }
     setContractAddress(newContractAddress);
     setClient(newClient);
   //}
  }
  const getNftsFrom = async (address) => {
   const tokensQuery = `
      query {
        erc721Transfers(
          first: 5,
          orderBy: timestamp,
          orderDirection:desc,
          where: {
            contract : "${contractAddress.toLowerCase()}",
            from: "0x0000000000000000000000000000000000000000",
            to: "${address.toLowerCase()}"
          }
        ) {
      	  id,
          token {
            identifier,
            uri
          }
      	}
    }
   `;
   const results = await client.query({
     query: gql(tokensQuery)
   });
   return(results);
 }
 const getLastNfts = async () => {
  const tokensQuery = `
     query {
       erc721Transfers(
         first: 5,
         orderBy: timestamp,
         orderDirection:desc,
         where: {
           contract : "${contractAddress.toLowerCase()}",
           from: "0x0000000000000000000000000000000000000000"
         }
       ) {
         id,
         token {
           identifier,
           uri
         }
       }
   }
  `;
  const results = await client.query({
    query: gql(tokensQuery)
  });
  return(results);
}
 return({client,initiateClient,contractAddress,getNftsFrom,getLastNfts})
}

export default useGraphClient;
