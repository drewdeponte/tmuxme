When(/^I go to the root of the web service$/) do
  visit root_path
end

Then(/^I should see the explanation of the service$/) do
  page.should have_content("The Landing Page")
end
