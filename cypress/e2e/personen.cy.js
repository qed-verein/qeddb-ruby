describe('personen', () => {
  it('should render', () => {
    cy.login('Admin', 'mypassword', { privileged: true })
    cy.get('nav').contains('Personen').click()
    cy.get('#people').should('exist')
  })
})
