describe('veranstaltungen', () => {
  it('should render', () => {
    cy.login('Admin', 'mypassword')
    cy.get('nav').contains('Veranstaltungen').click()
    cy.get('#events').should('exist')
  })

  it('should be possible to add and delete a veranstaltung', () => {
    const time = Date.now()
    const title = `Cypress ${time}`
    const today = new Date().toISOString().split('T')[0]
    const tomorrow = new Date(Date.now() + 86400000).toISOString().split('T')[0]

    cy.login('Admin', 'mypassword', { privileged: true })
    cy.get('nav').contains('Veranstaltungen').click()
    cy.contains('a.button', 'Neue Veranstaltung eintragen').click()

    cy.get('#event_title').clear().type(title)
    cy.get('#event_start').clear().type(today)
    cy.get('#event_end').clear().type(tomorrow)
    cy.get('#event_cost').clear().type('24.00')
    cy.get('#event_max_participants').clear().type('24')
    cy.get('input[type="submit"]').click()

    cy.visit('/events')
    cy.contains('a', title).click()

    // delete again
    cy.contains('a.button', 'Veranstaltung löschen').click()
    cy.get('.notice').should('contain', 'gelöscht')
  })
})
