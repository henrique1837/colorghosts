import React from 'react'
import styled from "styled-components";
import { Container, TextTitle, TextDescription } from "../styles/globalStyles"

const BannerContainer = styled(Container)`
  @media (min-width: 767px) {
    padding: 2rem;
  }
`;

export default function Banner({ title, subtitle }) {
  return <>
    <Container ai="center">
      <TextTitle>{title}</TextTitle>
      <TextDescription
        style={{
          textAlign: "center",
          color: "var(--primary-text)",
        }}
      >
        {subtitle}
      </TextDescription >
    </Container>
  </>
}
