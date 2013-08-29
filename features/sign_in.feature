Feature: Sign In

  In order to have access to manage my public keys
  As a User
  I want to be able to sign in with my credentials

  Scenario: A user signs in using their credentials
    Given I am a user
    When I fill out and submit the sign in form
    Then I should see the successfully logged in message

  Scenario: A user signs in with invalid credentials
    Given I am a user
    When I fill out and submit the sign in form with invalid credentials
    Then I should see an failed to log in message
