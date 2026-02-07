describe('veranstaltungen', () => {
  it('should render', () => {
    cy.login('Admin', 'mypassword')
    cy.get('nav').contains('Veranstaltungen').click()
    cy.get('#events').should('exist')
  })
})
