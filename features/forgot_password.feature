Feature: Forgot Password

  In order to gain access when I have forgotten my password
  As a User
  I want to be able to reset my password

  Scenario: A user resets his password using forgot password
    Given I am a user
    When I fill out and submit the forgot password form
    Then I should see the successfully sent password reset instructions email

  Scenario: A user resets their password using the link in the instructional email
    Given I am a user
    And I have received a password reset instructional email
    When I follow the link in the email
    And I fill out and submit the password reset form
    Then I should see the password has been reset message
