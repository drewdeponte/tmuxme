When(/^I notify the API of the created pairing session$/) do
  post '/api/v1/pairing_sessions', { system_username: 'adeponte', pairing_users: ['bob', 'cindy'] }
end

Then(/^I should get back a success message$/) do
  expect(last_response.status).to eq(200)
end
