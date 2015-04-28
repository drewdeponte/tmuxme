Given /^I am a user$/ do
  @user = User.create!(:email => 'someuser@tmuxme.com', :username => 'username', :password => 'bluepork', :password_confirmation => 'bluepork')
end

When /^I fill out and submit the sign in form$/ do
  visit(new_session_path)
  fill_in("email", :with => 'someuser@tmuxme.com')
  fill_in("password", :with => 'bluepork')
  click_button("Log In")
end

Then /^I should see the successfully logged in message$/ do
  expect(page).to have_content('Logged in!')
end

When /^I fill out and submit the sign in form with invalid credentials$/ do
  visit(new_session_path)
  fill_in("email", :with => 'someotheruser@tmuxme.com')
  fill_in("password", :with => 'someincorrectpassword')
  click_button("Log In")
end

Then /^I should see an failed to log in message$/ do
  expect(page).to have_content('Email or password is invalid!')
end
