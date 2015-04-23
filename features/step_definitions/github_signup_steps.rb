Given(/^I have a github account$/) do
end

When(/^I visit the signup page$/) do
  visit(new_user_path)
end

When(/^I click the github sign up button$/) do
  click_link("Sign up with GitHub")
end

Then(/^I should see a successfully signed up message$/) do
  expect(page).to have_content("Successfully signed up")
end

Then(/^I should see a warning that my account is already registered$/) do
  expect(page).to have_content("You have alreay registered an account. Login to link your Github account with your TmuxMe account")
end
