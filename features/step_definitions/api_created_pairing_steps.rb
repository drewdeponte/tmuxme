When(/^I notify the API of the created pairing session$/) do
  post '/api/v1/pairing_sessions', { system_user: 'adeponte', pairing_users: ['bob', 'cindy'], port_number: 23423 }
end

Then(/^I should get back a success message$/) do
  expect(last_response.status).to eq(200)
end
