import { Given, When, Then } from '@badeball/cypress-cucumber-preprocessor';

Given('I am on the SauceDemo login page', () => {
  cy.visit('https://www.saucedemo.com/');
});

When('I enter username {string}', (username) => {
  cy.get('#user-name').clear().type(username);
});

When('I enter password {string}', (password) => {
  cy.get('#password').clear().type(password);
});

When('I click the login button', () => {
  cy.get('#login-button').click();
});

Then('I should be navigated to the inventory page', () => {
  cy.url().should('include', '/inventory.html');
});

Then('I should see the error message {string}', (expectedMessage) => {
  cy.get('[data-test="error"]').should('have.text', expectedMessage);
});
