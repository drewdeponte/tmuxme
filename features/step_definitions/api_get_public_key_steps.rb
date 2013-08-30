Given(/^a user exists with a public key$/) do
  @user = User.create!(:username => 'someuser', :email => 'someuser@example.com', :password => 'bluepork', :password_confirmation => 'bluepork')
  @user.public_keys.create!(name: 'foo key', value: 'foo key value')
end

When(/^I request the public keys for that user$/) do
  get '/api/v1/users/someuser/public_keys.json'
end

Then(/^I should see the public keys$/) do
  expect(last_response.body).to eq("[\"foo key value\"]")
end
