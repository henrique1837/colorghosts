import React from 'react'
import { Container, ResponsiveWrapper, Screen, TextDescription, TextTitle,StyledLink } from "../styles/globalStyles"

export default function About() {
  return <Screen id="project" >
  <ResponsiveWrapper
    style={{
      textAlign: "left",
      color: "var(--primary-text)",
      padding: 24,
    }}
    flex={1}
  >
    <Container flex={1} style={{ margin: 'auto'}}>
      <TextTitle style={{
        fontSize: 50
      }}>
        About
      </TextTitle>
      <div style={{
        fontSize: 20
      }}>
        <p>GhostNColors are happy and colorful ghosts.</p>
        <p>100% onchain collection.</p>
        <p>GhostNColors are generated using <StyledLink target={"_blank"} href="https://boba.network/turing-hybrid-compute/" rel="noreferrer" style={{color: 'darkgrey'}}>Turing Hybrid Compute</StyledLink> from Boba Network,smart contract modified from <StyledLink target={"_blank"} href="https://github.com/omgnetwork/optimism-v2/tree/develop/boba_community/turing-monsters" rel="noreferrer" style={{color: 'darkgrey'}}>Turing Monsters</StyledLink>.</p>
        <p>GhostNColors are playable at <StyledLink target={"_blank"} href={'https://thevibes--space-crypto.ipns.dweb.link/#/colorghosts-v0'} rel="noreferrer" style={{color: 'darkgrey'}}>TheVibes Space</StyledLink></p>
      </div>
    </Container>
    <Container flex={1} ai="end" style={{ margin: 'auto'}}>
      <center>
        <img alt={"Color Ghosts"} src={"/config/images/logo_complete.png"} style={{width: '90%',borderRadius:'25%'}}/>
      </center>
    </Container>
  </ResponsiveWrapper>

</Screen>
}
