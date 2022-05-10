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


const TeamMember = ({img, name}) => (
  <div style={{ paddingBottom: '2rem', marginLeft: '1rem', marginRight: '1rem',textAlign:'center' }}>
    <img alt={name} src={img} style={{width: '150px'}}/>
    <TextDescription
      style={{
        textAlign: "center",
        color: "var(--primary-text)",
      }}
    >
      {name}
    </TextDescription >
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
        {members.map(({img, name}, idx) => <TeamMember key={`team-member-${idx}`} {...{img, name}} />)}
      </ResponsiveWrapper>
    </Container>
  )
}
