import React, { useEffect,useMemo, useState } from 'react'
import { ethers } from "ethers";

import {
  Container,
  ResponsiveWrapper,
  SpacerLarge,
  SpacerMedium,
  SpacerSmall,
  SpacerXSmall,
  StyledButton,
  StyledLink,
  StyledRoundButton,
  TextDescription,
  TextTitle
} from "../styles/globalStyles"
import useConfig from '../hooks/config';
import { useAppContext } from '../hooks/useAppState'


const truncate = (input, len) =>
  input.length > len ? `${input.substring(0, len)}...` : input;


export default function MintComponent(props) {



  const CONFIG = useConfig();
  const { state } = useAppContext();

  const [claimingNft, setClaimingNft] = useState(false);
  const [feedback, setFeedback] = useState(`Click buy to mint your NFT.`);
  const [mintAmount, setMintAmount] = useState(1);

  const claimNFTs = async () => {
    try{
      let totalCost = String(state.cost * mintAmount);
      console.log("Cost: ", totalCost);
      setFeedback(`Minting your GhostNColors ...`);
      setClaimingNft(true);
      const signer = state.provider.getSigner()
      const tokenWithSigner = state.contract.connect(signer);
      const tx = await tokenWithSigner.mint(mintAmount,{
        value: ethers.utils.parseEther(totalCost.toString())
      });
      setFeedback(
        `Waiting transaction confirmation`
      );
      await tx.wait();
      setFeedback(
        `GhostNColors will arrive soon!`
      );

      setTimeout(() => {
        setClaimingNft(false);
        setFeedback();

      },10000)
    } catch(err){
      let message = err.message
      try{
        console.log(message.split('error=')[1].split(', code=')[0].split('""}')[0])

        const obj = JSON.parse(message.split('error=')[1].split(', code=')[0].split('""}')[0].split(', method="estimateGas"')[0])
        console.log(obj);
        message = obj.message;

      } catch(err){
        console.log(err)
      }
      setFeedback(message);
      setClaimingNft(false);
      setTimeout(() => {
        setClaimingNft(false);
        setFeedback();

      },10000)
    }
  };

  const changeMintAmount = (e, number) => {
    e.preventDefault()
    let newMintAmount = mintAmount + number;
    if (newMintAmount < 1) {
      newMintAmount = 1;
    } else if (newMintAmount > 5) {
      newMintAmount = 5;
    }
    setMintAmount(newMintAmount);
  };




  return (
    <ResponsiveWrapper flex={1} style={{ padding: 24 }} test>
          <Container
            flex={2}
            jc={"center"}
            ai={"center"}
            style={{ padding: 24, borderRadius: 24 }}
            id="mint"
          >
            <TextTitle
              style={{
                textAlign: "center",
                fontSize: 50,
                fontWeight: "bold",
                color: "var(--accent-text)",
              }}
            >
              {state.totalSupply ? state.totalSupply : 0 } / {state.maxSupply ? state.maxSupply : 0}
            </TextTitle>
            <TextDescription
              style={{
                textAlign: "center",
                color: "var(--primary-text)",
              }}
            >
              <StyledLink target={"_blank"} href={
                `${state.netId === 4 ?
                 CONFIG.SCAN_LINK_RINKEBY :
                 state.netId === 28 ?
                 CONFIG.SCAN_LINK_BOBA_RINKEBY :
                 state.netId === 288 ?
                 CONFIG.SCAN_LINK_BOBA :
                 CONFIG.SCAN_LINK}/${state.contract?.address}`
              }>
                {state.contract && state.contract?.address}
              </StyledLink>
            </TextDescription>
            <SpacerSmall />
            {Number(state.totalSupply) >= Number(state.maxSupply) ? (
              <>
                <TextTitle
                  style={{ textAlign: "center", color: "var(--accent-text)" }}
                >
                  The sale has ended.
                </TextTitle>
                <TextDescription
                  style={{ textAlign: "center", color: "var(--accent-text)" }}
                >
                  You can still find {CONFIG.NFT_NAME} on
                </TextDescription>
                <SpacerSmall />
                <StyledLink target={"_blank"} href={
                  `${state.netId === 4 ?
                   CONFIG.MARKETPLACE_LINK_RINKEBY :
                   state.netId === 28 ?
                   CONFIG.MARKETPLACE_LINK_BOBA_RINKEBY :
                   CONFIG.MARKETPLACE_LINK}/${state.contract?.address}`
                }>
                  {
                    state.netId === 4 ?
                    CONFIG.MARKETPLACE_RINKEBY :
                    state.netId === 28 ?
                    CONFIG.MARKETPLACE_BOBA_RINKEBY :
                    state.netId === 288 ?
                    CONFIG.MARKETPLACE_BOBA :
                    CONFIG.MARKETPLACE
                  }
                </StyledLink>
              </>
            ) : (
              <>
                <TextTitle
                  style={{ textAlign: "center", color: "var(--accent-text)" }}
                >
                  1 {CONFIG.SYMBOL} costs {state.cost}{" ETH"}
                </TextTitle>
                <SpacerXSmall />
                <TextDescription
                  style={{ textAlign: "center", color: "var(--accent-text)" }}
                >
                  Excluding gas fee
                </TextDescription>
                <SpacerSmall />
                {
                  !state.coinbase ||
                  !state.contract ? (
                  <Container ai={"center"} jc={"center"}>
                    <TextDescription
                      style={{
                        textAlign: "center",
                        color: "var(--accent-text)",
                      }}
                    >
                      Connect to the {CONFIG.NETWORK.NAME} network
                    </TextDescription>
                    <SpacerSmall />

                    <StyledButton
                      onClick={async (e) => {
                        e.preventDefault();
                        await state.loadWeb3Modal();
                      }}
                    >
                      CONNECT
                    </StyledButton>
                  </Container>
                ) : (
                  <>
                    <TextDescription
                      style={{
                        textAlign: "center",
                        color: "var(--accent-text)",
                        wordBreak: "break-word"
                      }}
                    >
                      {feedback}
                    </TextDescription>
                    <SpacerMedium />
                    <Container ai={"center"} jc={"center"} fd={"row"}>
                      <StyledRoundButton
                        style={{ lineHeight: 0.4 }}
                        disabled={claimingNft ? 1 : 0}
                        onClick={(e) => changeMintAmount(e, -1)}
                      >
                        -
                      </StyledRoundButton>
                      <SpacerMedium />
                      <TextDescription
                        style={{
                          textAlign: "center",
                          color: "var(--accent-text)",
                        }}
                      >
                        {mintAmount}
                      </TextDescription>
                      <SpacerMedium />
                      <StyledRoundButton
                        disabled={claimingNft ? 1 : 0}
                        onClick={(e) => changeMintAmount(e, 1)}
                      >
                        +
                      </StyledRoundButton>
                    </Container>
                    <SpacerSmall />
                    <Container ai={"center"} jc={"center"} fd={"row"}>
                      <StyledButton
                        disabled={claimingNft ? 1 : 0}
                        onClick={async (e) => {
                          e.preventDefault();
                          await claimNFTs();
                        }}
                      >
                        {claimingNft ? "BUSY" : "BUY"}
                      </StyledButton>
                    </Container>
                  </>
                )}
              </>
            )}
            <SpacerMedium />
          </Container>
          <SpacerLarge />
    </ResponsiveWrapper>
  )
}
