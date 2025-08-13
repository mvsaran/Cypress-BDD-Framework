# Cypress BDD – SauceDemo (Step‑by‑Step Guide)

This repository contains a **Cypress** end‑to‑end test automation framework using **Cucumber (BDD)** to test the [SauceDemo](https://www.saucedemo.com) website.  
It follows a simple, modular structure with one feature file and its corresponding step definitions.

---

## ✅ What’s Included
- **Feature file** with `Background`, a positive login scenario, and a **Scenario Outline** for invalid credentials.
- **Step definitions** implementing each Gherkin step with Cypress commands.
- **Cucumber preprocessor** setup (using `@badeball/cypress-cucumber-preprocessor`) with ESBuild bundler.

---

## 🧱 Folder Structure (as in your project)
```
CYPRESSBDD/
├── cypress/
│   ├── e2e/
│   │   ├── saucedemo.feature
│   │   └── saucedemo/
│   │       └── saucedemo.js
│   ├── fixtures/
│   │   └── example.json
│   └── support/
│       ├── commands.js
│       └── e2e.js
├── cypress.config.js
├── package.json
└── package-lock.json
```

> **Note:** The step definitions live in `cypress/e2e/saucedemo/saucedemo.js`, while the feature file is `cypress/e2e/saucedemo.feature`.

---

## 🧰 Prerequisites
- **Node.js** v16 or later (v18+ recommended)
- **npm** (bundled with Node.js)
- A modern browser (Chrome, Edge, or Electron works out of the box)

Check your versions:
```bash
node -v
npm -v
```

---

## 📦 Install Dependencies (from scratch or to update)
From the project root:
```bash
npm install --save-dev cypress @badeball/cypress-cucumber-preprocessor @bahmutov/cypress-esbuild-preprocessor esbuild
```

This installs:
- `cypress` – test runner
- `@badeball/cypress-cucumber-preprocessor` – BDD support
- `@bahmutov/cypress-esbuild-preprocessor` + `esbuild` – fast bundling for step files

---

## ⚙️ Configure `cypress.config.js`
Use the following minimal, working configuration (compatible with Cypress 12+ / 13+):

```js
const { defineConfig } = require("cypress");
const createBundler = require("@bahmutov/cypress-esbuild-preprocessor");
const createEsbuildPlugin = require("@badeball/cypress-cucumber-preprocessor/esbuild").createEsbuildPlugin;
const cucumber = require("@badeball/cypress-cucumber-preprocessor");

async function setupNodeEvents(on, config) {
  // Register the Cucumber plugin
  await cucumber.addCucumberPreprocessorPlugin(on, config);

  // Use esbuild for bundling step definition files
  on("file:preprocessor", createBundler({
    plugins: [createEsbuildPlugin(config)],
  }));

  return config;
}

module.exports = defineConfig({
  e2e: {
    specPattern: "cypress/e2e/**/*.feature",
    supportFile: "cypress/support/e2e.js",
    baseUrl: "https://www.saucedemo.com",
    setupNodeEvents,
  },
});
```

> If your project already has this file, compare and align the key parts: `specPattern`, `setupNodeEvents`, and the two preprocessors.

---

## 🗂️ Feature & Step Definition (your current files)

**`cypress/e2e/saucedemo.feature`**
```gherkin
Feature: SauceDemo Login

  As a SauceDemo user
  I want to login with valid credentials
  So that I can access the inventory page

  Background:
    Given I am on the SauceDemo login page

  Scenario: Successful login with valid credentials
    When I enter username "standard_user"
    And I enter password "secret_sauce"
    And I click the login button
    Then I should be navigated to the inventory page

  Scenario Outline: Login with invalid credentials
    When I enter username "<username>"
    And I enter password "<password>"
    And I click the login button
    Then I should see the error message "<errorMessage>"

    Examples:
      | username      | password     | errorMessage                                                      |
      | invalid_user  | secret_sauce | Epic sadface: Username and password do not match any user in this service |
      | standard_user | wrong_pass   | Epic sadface: Username and password do not match any user in this service |
```

**`cypress/e2e/saucedemo/saucedemo.js`**
```javascript
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
```

---

## 🏃‍♀️ Run Tests

### 1) Open the Cypress GUI
```bash
npx cypress open
```
- Choose **E2E Testing** → select a browser → click **`saucedemo.feature`** to execute.

### 2) Run headless (CI-friendly)
```bash
npx cypress run --spec "cypress/e2e/saucedemo.feature"
```

### 3) (Optional) Add npm scripts to `package.json`
```jsonc
{
  "scripts": {
    "cypress:open": "cypress open",
    "cypress:run": "cypress run --spec 'cypress/e2e/saucedemo.feature'"
  }
}
```

Then you can run:
```bash
npm run cypress:open
# or
npm run cypress:run
```

---

## 🧪 Tips & Good Practices
- Keep **selectors stable** by using `data-test` attributes when available (SauceDemo provides them).
- Co-locate steps with features (current layout is fine). For larger apps, group by domain (e.g., `checkout`, `cart`, `login`).
- Use **Scenario Outlines** for data-driven testing (as shown above).

---

## 🛠️ Troubleshooting

**1) “We couldn’t find any step definitions”**
- Ensure you installed all dev dependencies listed above.
- Confirm your `cypress.config.js` contains the plugin setup and `specPattern` for `.feature` files.
- Make sure your step defs are compiled by the preprocessor (they are under `cypress/e2e/**`, which is correct).

**2) “Cannot find module '@badeball/cypress-cucumber-preprocessor'”**
- Reinstall: `rm -rf node_modules package-lock.json && npm install`

**3) Tests run, but fail at login**
- Double-check credentials for the valid scenario (`standard_user` / `secret_sauce`).
- Ensure the error message text in examples exactly matches the UI message.

---

## 🤝 Contributing
1. Create a feature branch: `git checkout -b feat/new-tests`
2. Commit changes: `git commit -m "Add new BDD tests"`
3. Push and open a PR.


