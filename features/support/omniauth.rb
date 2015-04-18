Before('@omniauth_test') do
  OmniAuth.config.test_mode = true
  Capybara.default_host = 'http://example.com'

  OmniAuth.config.add_mock(:github, {
    uid: '12345',
    provider: 'github',
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

After('@omniauth_test') do
  OmniAuth.config.test_mode = false
end
