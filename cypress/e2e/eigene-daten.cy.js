describe('eigene daten', () => {
  it('should render', () => {
    cy.login('Admin', 'mypassword')
    cy.get('nav').contains('Eigene Daten').click()
    cy.get('.panel').should('contain', 'Personendaten')
  })
})
