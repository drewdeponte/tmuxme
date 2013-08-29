When /^I fill out and submit the signup form$/ do
  visit(new_user_path)
  fill_in("user[email]", :with => 'foo@example.com')
  fill_in("user[password]", :with => 'porkporkpork')
  fill_in("user[password_confirmation]", :with => 'porkporkpork')
  click_button("Sign Up")
end

Then /^I should see the successfully signed up message$/ do
  page.should have_content("Thank you for signing up!")
end

Given(/^I am a guest$/) do
end
