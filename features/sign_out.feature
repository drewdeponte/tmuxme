Feature: Sign Out

  In order to protect my account
  As a User
  I want to be able to sign out

  Scenario: A signed in user signs out
    Given I am a user
    And I fill out and submit the sign in form
    When I sign out
    Then I should see the successfully logged out message
