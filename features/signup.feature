Feature: Signup

  In order to have manage my public keys
  As a Guest
  I want to be able to signup for an account

  Scenario: A guest signsup for an account
    Given I am a guest
    When I fill out and submit the signup form
    Then I should see the successfully signed up message
