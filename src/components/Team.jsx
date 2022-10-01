import React from 'react'
import styled from 'styled-components';
import {Container, ResponsiveWrapper, SpacerLarge, TextDescription, TextTitle,StyledLink}from '../styles/globalStyles'

const Avatar = styled('div')`
    background-image: url(${props => props.src});
    background-size: cover;
    background-position: top center;
    border-radius: 50%;
    height: 12rem;
    width: 12rem;
    margin: auto;
`;


const TeamMember = ({img, name,did}) => (
  <div style={{ paddingBottom: '2rem', marginLeft: '1rem', marginRight: '1rem',textAlign:'center' }}>
    <a href={`https://orbis.club/profile/${did}`} target="_blank" rel="noreferrer">
    <img alt={name} src={img} style={{width: '150px'}}/>
    <TextDescription
      style={{
        textAlign: "center",
        color: "var(--primary-text)",
      }}
    >
      {name}
    </TextDescription >
    </a>
  </div>
)

export default function Team({members}) {
  return (
    <Container id="team" jc="center" ai="center">
      <TextTitle
        style={{
          textAlign: "center",
          color: "var(--primary-text)",
          paddingTop: "2rem",
        }}
      >
        Team
      </TextTitle>
      <SpacerLarge />
      <ResponsiveWrapper style={{justifyContent: 'center'}}>
        {members.map(({img, name, did}) => <TeamMember key={`team-member-${did}`} {...{img, name,did}} />)}
      </ResponsiveWrapper>
    </Container>
  )
}
