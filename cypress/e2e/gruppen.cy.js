describe('gruppen', () => {
  it('should render', () => {
    cy.login('Admin', 'mypassword', { privileged: true })
    cy.get('nav').contains('Gruppen').click()
    cy.get('#groups').should('exist')
  })
})
