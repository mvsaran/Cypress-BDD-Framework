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
      