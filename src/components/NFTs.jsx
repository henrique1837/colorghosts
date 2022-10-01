import React from 'react'
import styled from 'styled-components';
import {Container, ResponsiveWrapper, SpacerLarge, TextDescription, TextTitle}from '../styles/globalStyles'

const Avatar = styled('div')`
    background-image: url(${props => props.src});
    background-size: cover;
    background-position: top center;
    border-radius: 50%;
    height: 12rem;
    width: 12rem;
    margin: auto;
`;

import { useAppContext } from '../hooks/useAppState'

const NFT = ({image_data,name,attributes}) => (
  <div flex={1} style={{ paddingBottom: '2rem', marginLeft: '1rem', marginRight: '1rem',textAlign:'center' }} >
    <img alt={name} src={image_data} style={{width:'150px'}} />
    <TextDescription
      style={{
        textAlign: "center",
        color: "var(--primary-text)",
      }}
    >
      <p>{name}</p>
      <p>Velocity: {attributes[1].value}</p>
    </TextDescription >
  </div>
)

export default function NFTs({nfts,title}) {
  if(nfts.length > 5){
    nfts.slice(0,4);
  }
  return (
    <Container id="nfts" jc="center" ai="center">
      <TextTitle
        style={{
          textAlign: "center",
          color: "var(--primary-text)",
          paddingTop: "2rem",
        }}
      >
        {title}
      </TextTitle>
      <SpacerLarge />
      <ResponsiveWrapper style={{justifyContent: 'center'}} flex={1}>
        {nfts.map(({image_data, name , attributes }) => <NFT key={`team-member-${name}`} {...{image_data, name,attributes}} />)}
      </ResponsiveWrapper>
    </Container>
  )
}
