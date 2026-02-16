Cypress.Commands.add("login", (username, password, options = {}) => {
  const { privileged = false } = options;

  cy.visit("/login");
  cy.get('input[name="authenticity_token"]')
    .invoke("attr", "value")
    .then((token) => {
      cy.request({
        method: "POST",
        url: "/login",
        form: true,
        body: {
          account_name: username,
          password: password,
          authenticity_token: token,
        },
        followRedirect: true,
      });
    });

  if (privileged) {
    cy.get('meta[name="csrf-token"]')
      .invoke("attr", "content")
      .then((csrfToken) => {
        cy.request({
          method: "POST",
          url: "/admin/privileged_mode",
          form: true,
          body: {
            authenticity_token: csrfToken,
          },
          followRedirect: true,
        });
      });
  }

  cy.visit("/");
});
