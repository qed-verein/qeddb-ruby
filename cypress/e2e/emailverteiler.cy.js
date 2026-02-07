describe('emailverteiler', () => {
  it('should render', () => {
    cy.login('Admin', 'mypassword', { privileged: true })
    cy.get('nav').contains('Emailverteiler').click()
    cy.get('#mailinglists').should('exist')
  })

  it('should be possible to add and delete a mailing list', () => {
    const stamp = Date.now()
    const title = `Cypress Mailinglist ${stamp}`

    cy.login('Admin', 'mypassword', { privileged: true })
    cy.get('nav').contains('Emailverteiler').click()
    cy.contains('a.button', 'Neuen Emailverteiler erstellen').click()

    cy.get('input[name="mailinglist[title]"]').clear().type(title)
    cy.get('input[type="submit"]').click()

    cy.visit('/mailinglists')
    cy.contains('a', title).click()

    // delete again
    cy.contains('a.button', 'Emailverteiler löschen').click()
    cy.get('.notice').should('contain', 'gelöscht')
  })
})
