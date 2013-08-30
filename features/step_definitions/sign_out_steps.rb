When /^I sign out$/ do
  click_link 'Sign Out'
end

Then /^I should see the successfully logged out message$/ do
  page.should have_content('Logged out!')
end
