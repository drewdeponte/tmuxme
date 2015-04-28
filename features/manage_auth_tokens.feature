Feature: Auth Token Management
  In order to manage all of my auth token grants
  As a User with granted auth tokens
  I want to be able add or remove auth tokens

  @omniauth_test
  Scenario: A user views all registered auth tokens
    Given I am a user
    And I am logged in
    And I have a github token registered
    When I visit the auth token management page
    Then I should see the granted github token

  @omniauth_test
  Scenario: A user removes a registered auth token
    Given I am a user
    And I am logged in
    And I have a github token registered
    When I visit the auth token management page
    And I remove the granted github token
    Then I should see an auth token removal success message
    And I should not see the github token
