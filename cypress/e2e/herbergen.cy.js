describe('herbergen', () => {
  it('should render', () => {
    cy.login('Admin', 'mypassword', { privileged: true })
    cy.get('nav').contains('Herbergen').click()
    cy.get('#hostels').should('exist')
  })

  it('should be possible to add and delete a hostel', () => {
    const time = Date.now()
    const title = `Cypress ${time}`

    cy.login('Admin', 'mypassword', { privileged: true })
    cy.get('nav').contains('Herbergen').click()
    cy.contains('a.button', 'Neue Herberge eintragen').click()

    cy.get('#hostel_title').clear().type(title)
    cy.get('input[name="hostel[address_attributes][street_name]"]').clear().type('Zypressenstraße')
    cy.get('input[name="hostel[address_attributes][house_number]"]').clear().type('24')
    cy.get('input[name="hostel[address_attributes][postal_code]"]').clear().type('65537')
    cy.get('input[name="hostel[address_attributes][city]"]').clear().type('Sonthofen')
    cy.get('input[type="submit"]').click()

    cy.visit('/hostels')
    cy.contains('a', title).click()

    // delete again
    cy.on('window:confirm', () => true)
    cy.contains('a.button', 'Herberge löschen').click()
    cy.get('.notice').should('contain', 'gelöscht')
  })
})
