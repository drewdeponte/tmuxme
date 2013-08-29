Given(/^I have a public key$/) do
  @user.public_keys.create!(name: "my bar key", value: "the actual bar key value")
end

Given(/^I am logged in$/) do
  login('someuser@example.com', 'bluepork')
end

When(/^I go to the public keys page$/) do
  visit '/public_keys'
end

Then(/^I should see my public keys$/) do
  page.should have_content("my bar key")
  page.should have_content("the actual bar key value")
end
