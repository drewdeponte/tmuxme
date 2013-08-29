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
  expect(page).to have_content("my bar key")
  expect(page).to have_content("the actual bar key value")
end

When(/^I fill out the add public key form$/) do
  visit '/public_keys/new'
  fill_in 'Name', with: 'test key name'
  fill_in 'Value', with: 'test key value'
  click_button 'submit'
end

Then(/^I should see public key I just added$/) do
  expect(page).to have_content('test key name')
  expect(page).to have_content('test key value')
end
