import React from 'react'
import styled from 'styled-components';
import { Container, TextTitle } from "../styles/globalStyles"
import OrbisLogo from "../assets/icons/orbis-logo.png";
import BobaLogo from "../assets/icons/boba.svg";

const BottomContainer = styled(Container)`
  padding: 1rem;
  justify-content: center;
`;

const SocialMediaLink = styled('a').attrs({
  target: "_blank",
  rel: "noopener noreferrer"
})`
  margin: 2rem;
`;

export default function Footer() {
  return(
  <Container jc="center" ai="center">
    <BottomContainer fd="row">
      <SocialMediaLink href="https://app.orbis.club/group/kjzl6cwe1jw146i8dmqbe4nrc1w0iac8ycrrm2jz1j5u6nnezq2evkxjv6orcpw"><img src={OrbisLogo} style={{width:'50px'}} /></SocialMediaLink>
      <SocialMediaLink href="https://gateway.boba.network/"><img src={BobaLogo} style={{width:'40px'}} /></SocialMediaLink>

    </BottomContainer>
  </Container>
  )
}
