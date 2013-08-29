Feature: View Landing Page

  In order to understand the service
  As a Guest
  I want to be able to view the landing page

  Scenario: A guest views the landing page
    Given I am a guest
    When I go to the root of the web service
    Then I should see the explanation of the service
