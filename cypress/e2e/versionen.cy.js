describe('versionen', () => {
  it('should render', () => {
    cy.login('Admin', 'mypassword', { privileged: true })
    cy.get('nav').contains('Versionen').click()
    cy.get('#versions').should('exist')
  })
})
