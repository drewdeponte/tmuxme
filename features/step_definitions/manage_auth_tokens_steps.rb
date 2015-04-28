When(/^I visit the auth token management page$/) do
  visit(auth_tokens_path)
end

Then(/^I should see the granted github token$/) do
  expect(page).to have_content("Github")
end

When(/^I remove the granted github token$/) do
  click_link("Remove")
end

Then(/^I should see an auth token removal success message$/) do
  expect(page).to have_content("Token successfully removed")
end

Then(/^I should not see the github token$/) do
  expect(page).to have_content("Link my Github account")
end

When(/^I click on the link github account button$/) do
  click_link("Link my Github account")
end
