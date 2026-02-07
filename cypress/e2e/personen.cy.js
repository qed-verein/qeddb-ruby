describe('personen', () => {
  it('should render', () => {
    cy.login('Admin', 'mypassword', { privileged: true })
    cy.get('nav').contains('Personen').click()
    cy.get('#people').should('exist')
  })

  it('should be possible to add and delete a person', () => {
    const time = Date.now()
    const accountName = `cypress_${time}`
    const email = `cypress_${time}@example.com`
    const firstName = 'Cypress'
    const lastName = `${time}`

    cy.login('Admin', 'mypassword', { privileged: true })
    cy.get('nav').contains('Personen').click()
    cy.contains('a.button', 'Neue Person eintragen').click()

    cy.get('#person_account_name').clear().type(accountName)
    cy.get('#person_email_address').clear().type(email)
    cy.get('#person_first_name').clear().type(firstName)
    cy.get('#person_last_name').clear().type(lastName)
    cy.get('input[type="submit"]').click()

    cy.visit('/people')
    cy.contains('a', `${firstName} ${lastName}`).click()

    // delete again
    cy.on('window:confirm', () => true)
    cy.contains('a.button', 'Person löschen').click()
    cy.get('.notice').should('contain', 'gelöscht')
  })
})
