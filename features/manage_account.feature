Feature: Account Management

  In order to maange my account
  As a User
  I want to be able to update my account information

  Scenario: A user updates their email
    Given I am a user
    And I am logged in
    When I visit the edit account page
    And I update my email address
    Then I should see the update successful message
    And I should see the updated email address

  Scenario: A user updates their password
    Given I am a user
    And I am logged in
    When I visit the edit account page
    And I update my password
    Then I should see the update successful message
    When I log out
    And I log in with my new password
    Then I should see the successfully logged in message
