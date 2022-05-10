import React from 'react'
import styled from 'styled-components';
import { Container, TextTitle } from "../styles/globalStyles"
import { ReactComponent as TwitterIcon } from '../assets/icons/twitter.svg'
import { ReactComponent as TelegramIcon } from '../assets/icons/telegram.svg';
import { ReactComponent as DiscordIcon } from '../assets/icons/discord.svg';
import { ReactComponent as InstagramIcon } from '../assets/icons/instagram.svg';

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
      <SocialMediaLink href="https://twitter.com/GhostNColors"><TwitterIcon /></SocialMediaLink>
    </BottomContainer>
  </Container>
  )
}
