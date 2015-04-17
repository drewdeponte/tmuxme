When /^I sign out$/ do
  click_link 'Sign Out'
end

Then /^I should see the successfully logged out message$/ do
  expect(page).to have_content('Logged out!')
end
