When /^I fill out and submit the forgot password form$/ do
  visit new_password_reset_path
  fill_in "email", :with => 'someuser@tmuxme.com'
  click_button 'Request Password Reset'
end

Then /^I should see the successfully sent password reset instructions email$/ do
  expect(page).to have_content("We sent an email to you with instructions on how to reset your password.")
end

Given /^I have received a password reset instructional email$/ do
  @user.password_reset_token = 'foobartesttoken'
  @user.password_reset_sent_at = Time.zone.now
  @user.save!
end

When /^I follow the link in the email$/ do
  visit edit_password_reset_path('foobartesttoken')
end

When /^I fill out and submit the password reset form$/ do
  fill_in "user[password]", :with => 'jackieboy'
  fill_in "user[password_confirmation]", :with => 'jackieboy'
  click_button 'Update Password'
end

Then /^I should see the password has been reset message$/ do
  expect(page).to have_content('Password has been reset')
end
