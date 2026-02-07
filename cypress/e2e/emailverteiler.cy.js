describe('emailverteiler', () => {
  it('should render', () => {
    cy.login('Admin', 'mypassword', { privileged: true })
    cy.get('nav').contains('Emailverteiler').click()
    cy.get('#mailinglists').should('exist')
  })
})
