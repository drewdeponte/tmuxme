Feature: Get Public Keys via API

  In order to allow user access
  As the client
  I want to be able to get the users public keys

  Scenario: A guest gets the public keys for user
    Given I am a guest
    And a user exists with a public key
    When I request the public keys for that user
    Then I should see the public keys
