Feature: Manage Public Keys

  In order to use the tmux.me service
  As a User
  I want to be able to manage my public keys

  Scenario: A user views all of his public keys 
    Given I am a user
    And I am logged in
    And I have a public key
    When I go to the public keys page
    Then I should see my public keys

  Scenario: A user adds a public key to his/her collection

  Scenario: A user removes a public key from his/her collection
