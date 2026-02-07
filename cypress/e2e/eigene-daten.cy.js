describe('eigene daten', () => {
  it('should render', () => {
    cy.login('Admin', 'mypassword')
    cy.get('nav').contains('Eigene Daten').click()
    cy.get('.panel').should('contain', 'Personendaten')
  })

  it('should allow updating Anmerkungen', () => {
    cy.login('Admin', 'mypassword')
    cy.get('nav').contains('Eigene Daten').click()
    cy.contains('a', 'Mitgliedsdaten bearbeiten').click()

    cy.get('#person_comment').invoke('val').then((originalComment) => {
      const original = originalComment || ''
      const time = Date.now()
      const updated = `Cypress ${time}`

      cy.get('#person_comment').clear().type(updated)
      cy.get('input[type="submit"]').click()

      cy.contains('a', 'Mitgliedsdaten bearbeiten').click()
      cy.get('#person_comment').should('have.value', updated)

      cy.get('#person_comment').clear().type(original)
      cy.get('input[type="submit"]').click()

      cy.contains('a', 'Mitgliedsdaten bearbeiten').click()
      cy.get('#person_comment').should('have.value', original)
    })
  })
})
