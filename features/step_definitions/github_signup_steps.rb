Given(/^I have a github account$/) do
end

When(/^I visit the signup page$/) do
  visit(new_user_path)
end

When(/^I click the github sign up button$/) do
  click_link("Sign up with GitHub")
end
