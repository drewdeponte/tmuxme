Feature: Signal Created Pairing via API

  In order to notify the invited users
  As the client
  I want to be able to signal tmux.me to notify the inivted users the new pairing session.

  Scenario: A guest notifies the API about a pairing session
    Given I am a guest
    And a user exists with a public key
    When I notify the API of the created pairing session
    Then I should get back a success message
