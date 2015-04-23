When(/^I visit the login page$/) do
  visit(new_session_path)
end

When(/^I click the github login button$/) do
  click_link("Sign in with GitHub")
end

Then(/^I should see a successfully signed in message$/) do
  expect(page).to have_content("Successfully logged in")
end

Then(/^I should see the user greeting for "(.*?)"$/) do |username|
  expect(page).to have_content("Hi #{username}!")
end

Given(/^I have a github token registered$/) do
  @user.auth_tokens.create(uid: '12345', provider: 'github')
end
