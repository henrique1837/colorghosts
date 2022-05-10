import React from 'react'
import styled from "styled-components";
import { Container, MenuLink, SpacerXSmall } from "../styles/globalStyles"

const MenuContainer = styled(Container)`
  padding: 16px;
`;

export default function Menu({ links }) {
  return <MenuContainer fd="row" jc="flex-end">
    {links.map((option) => <><MenuLink href={`${option.href}`}>{option.label}</MenuLink><SpacerXSmall /></>)}
  </MenuContainer>
}
