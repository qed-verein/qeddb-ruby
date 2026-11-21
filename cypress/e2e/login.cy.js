describe("login", () => {
  it("should work via UI", () => {
    cy.visit("/login");

    // invalid credentials
    cy.get("input#account_name").type("Admin");
    cy.get("input#password").type("wrongpassword");
    cy.get('fieldset input[type="submit"]').click();

    cy.get(".error").should("contain", "Login fehlgeschlagen");

    // valid credentials
    cy.get("input#account_name").clear().type("Admin");
    cy.get("input#password").clear().type("mypassword");
    cy.get('fieldset input[type="submit"]').click();

    cy.get(".notice").should("contain", "Login erfolgreich");
  });

  it("should work via API", () => {
    cy.login("Admin", "mypassword");
    cy.visit("/");
    cy.get("body").should("contain", "Ausloggen");
  });

  it("should work via API (privileged mode)", () => {
    cy.login("Admin", "mypassword", { privileged: true });
    cy.get("button").should("contain", "Standardmodus");
  });
});
