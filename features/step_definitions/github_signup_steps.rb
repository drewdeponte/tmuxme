Given(/^I have a github account$/) do
end

When /^the sign up using github was successful$/ do
  OmniAuth.config.add_mock(:github, {
    uid: '12345',
    info: {
      nickname: 'nickname',
      email: 'email',
      name: 'name',
      image: 'avatar_url',
      urls: {
        GitHub: 'html_url',
        Blog: 'blog'
      }
    },
    credentials: {
      token: 'token'
    }
  })
end

When(/^I visit the signup page$/) do
  visit(new_user_path)
end

When(/^I click the github sign up button$/) do
  click_link("Sign up with GitHub")
end
