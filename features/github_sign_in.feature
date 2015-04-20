Feature: Github Sign In

  In order to have access to manage my public keys
  As a User with a github account
  I want to be able to sign in with my github account

  @omniauth_test
  Scenario: A guest successfully signs in using their github account
    Given I am a user
    And I have a github token registered
    When I visit the login page
    And I click the github login button
    Then I should see the user greeting for "username"

