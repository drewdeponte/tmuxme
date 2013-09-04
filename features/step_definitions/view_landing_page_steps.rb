When(/^I go to the root of the web service$/) do
  visit root_path
end

Then(/^I should see the explanation of the service$/) do
  page.should have_content("The easiest way to share a tmux session with friends, co-workers, etc.")
end
