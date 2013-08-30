When(/^I go to the root of the web service$/) do
  visit root_path
end

Then(/^I should see the explanation of the service$/) do
  page.should have_content("is a tool that allows you to securely host or join a shared tmux session")
end
