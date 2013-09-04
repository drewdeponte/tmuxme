Given(/^a user exists with a public key$/) do
  @user = User.create!(:username => 'someuser', :email => 'someuser@example.com', :password => 'bluepork', :password_confirmation => 'bluepork')
  @user.public_keys.create!(name: 'foo key', value: 'ssh-dss AAAAB3NzaC1kc3MAAACBAKImSRgTHIEx61gZDYkj6QEpukwoiplXXv+D7lrOYCiRFuecQ2r5dhHTaNu8uGf79H5Tz83opBIwdqJCE3IMlINNj/tFmaDEdyeNtjkbk/9qmUDAgZ/FfCnU7SaGRZY2PslL3BhLYAZM2XNFaCKWb1mbCKJRCsCRLOqHxBIIXBm9AAAAFQDwKU42BMEnxK0dng2L4GdDTaP30wAAAIEAgYzS5jzIdRRLo+dcZQpMQeXR6HZyhrsCtzme/GZl7jwd/KsfKFKqecQMid+ENK5dImAFUbYN0RuWFeZ9Ssrd+KrEq0GcUQuy6+eJtJGaMoCrKcpQY+CZyexyvJ6fpkIlR/WhIZS/ZAzYVtc58mbJnf0KUhQB1FsKwb7kMp4SJuYAAACBAJinHd4YGS/a7fqA5KgrleZUqBnYPAsa12BduCv/P/3vQhEnY8rhaYOboWUxaTuo/ePnetOyuIz6kSISJG97b+oUFpx28pGXDcCcGQIgHnZkiSk0845LmzSqzjCMf75jf0+Ez6SxjUe+aOxXjIZXM9euA9nq7hdbpQ6Luh1j79Rd adeponte@andrew-de-pontes-macbook-pro.local')
end

When(/^I request the public keys for that user$/) do
  get '/api/v1/users/someuser/public_keys.json'
end

Then(/^I should see the public keys$/) do
  expect(last_response.body).to eq("[\"ssh-dss AAAAB3NzaC1kc3MAAACBAKImSRgTHIEx61gZDYkj6QEpukwoiplXXv+D7lrOYCiRFuecQ2r5dhHTaNu8uGf79H5Tz83opBIwdqJCE3IMlINNj/tFmaDEdyeNtjkbk/9qmUDAgZ/FfCnU7SaGRZY2PslL3BhLYAZM2XNFaCKWb1mbCKJRCsCRLOqHxBIIXBm9AAAAFQDwKU42BMEnxK0dng2L4GdDTaP30wAAAIEAgYzS5jzIdRRLo+dcZQpMQeXR6HZyhrsCtzme/GZl7jwd/KsfKFKqecQMid+ENK5dImAFUbYN0RuWFeZ9Ssrd+KrEq0GcUQuy6+eJtJGaMoCrKcpQY+CZyexyvJ6fpkIlR/WhIZS/ZAzYVtc58mbJnf0KUhQB1FsKwb7kMp4SJuYAAACBAJinHd4YGS/a7fqA5KgrleZUqBnYPAsa12BduCv/P/3vQhEnY8rhaYOboWUxaTuo/ePnetOyuIz6kSISJG97b+oUFpx28pGXDcCcGQIgHnZkiSk0845LmzSqzjCMf75jf0+Ez6SxjUe+aOxXjIZXM9euA9nq7hdbpQ6Luh1j79Rd adeponte@andrew-de-pontes-macbook-pro.local\"]")
end
