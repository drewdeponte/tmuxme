When(/^I visit the edit account page$/) do
  visit edit_account_path
end

When(/^I update my email address$/) do
  fill_in 'user_email', with: 'email@address.com'
  click_button 'Update'
end

Then(/^I should see the update successful message$/) do
  expect(page).to have_content("Update Successful")
end

Then(/^I should see the updated email address$/) do
  expect(page).to have_content('email@address.com')
end

When(/^I update my password$/) do
  fill_in 'user_password', with: 'mynewpassword'
  fill_in 'user_password_confirmation', with: 'mynewpassword'
  click_button 'Update'
end

When(/^I log out$/) do
  click_link "Sign Out"
end

When(/^I log in with my new password$/) do
  visit(new_session_path)
  fill_in("email", :with => 'someuser@tmuxme.com')
  fill_in("password", :with => 'mynewpassword')
  click_button("Log In")
end
