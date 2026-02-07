describe('gruppen', () => {
  it('should render', () => {
    cy.login('Admin', 'mypassword', { privileged: true })
    cy.get('nav').contains('Gruppen').click()
    cy.get('#groups').should('exist')
  })

  it('should be possible to add and subtract in a group', () => {
    const time = Date.now()
    const title = `Cypress ${time}`

    cy.login('Admin', 'mypassword', { privileged: true })
    cy.get('nav').contains('Gruppen').click()
    cy.contains('a.button', 'Neue Gruppe erstellen').click()

    cy.get('input[name="group[title]"]').clear().type(title)
    cy.get('input[type="submit"]').click()

    cy.visit('/groups')
    cy.contains('a', title).click()

    // delete again
    cy.on('window:confirm', () => true)
    cy.contains('a.button', 'Gruppe löschen').click()
    cy.get('.notice').should('contain', 'gelöscht')
  })
})
