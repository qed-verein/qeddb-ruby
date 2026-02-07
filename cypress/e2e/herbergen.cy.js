describe('herbergen', () => {
  it('should render', () => {
    cy.login('Admin', 'mypassword', { privileged: true })
    cy.get('nav').contains('Herbergen').click()
    cy.get('#hostels').should('exist')
  })
})
