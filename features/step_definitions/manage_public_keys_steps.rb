Given(/^I have a public key$/) do
  @user.public_keys.create!(name: "my bar key", value: "ssh-dss AAAAB3NzaC1kc3MAAACBAKImSRgTHIEx61gZDYkj6QEpukwoiplXXv+D7lrOYCiRFuecQ2r5dhHTaNu8uGf79H5Tz83opBIwdqJCE3IMlINNj/tFmaDEdyeNtjkbk/9qmUDAgZ/FfCnU7SaGRZY2PslL3BhLYAZM2XNFaCKWb1mbCKJRCsCRLOqHxBIIXBm9AAAAFQDwKU42BMEnxK0dng2L4GdDTaP30wAAAIEAgYzS5jzIdRRLo+dcZQpMQeXR6HZyhrsCtzme/GZl7jwd/KsfKFKqecQMid+ENK5dImAFUbYN0RuWFeZ9Ssrd+KrEq0GcUQuy6+eJtJGaMoCrKcpQY+CZyexyvJ6fpkIlR/WhIZS/ZAzYVtc58mbJnf0KUhQB1FsKwb7kMp4SJuYAAACBAJinHd4YGS/a7fqA5KgrleZUqBnYPAsa12BduCv/P/3vQhEnY8rhaYOboWUxaTuo/ePnetOyuIz6kSISJG97b+oUFpx28pGXDcCcGQIgHnZkiSk0845LmzSqzjCMf75jf0+Ez6SxjUe+aOxXjIZXM9euA9nq7hdbpQ6Luh1j79Rd adeponte@andrew-de-pontes-macbook-pro.local")
end

Given(/^I am logged in$/) do
  login('someuser@tmuxme.com', 'bluepork')
end

When(/^I go to the public keys page$/) do
  visit '/public_keys'
end

Then(/^I should see my public keys$/) do
  expect(page).to have_content("my bar key")
  expect(page).to have_content("ssh-dss AAAAB3NzaC1kc3MAAACBAKImSRgTHIEx61gZDYkj6QEpukwoiplXXv+D7lrOYCiRFuecQ2r5dhHTaNu8uGf79H5Tz83opBIwdqJCE3IMlINNj/tFmaDEdyeNtjkbk/9qmUDAgZ/FfCnU7SaGRZY2PslL3BhLYAZM2XNFaCKWb1mbCKJRCsCRLOqHxBIIXBm9AAAAFQDwKU42BMEnxK0dng2L4GdDTaP30wAAAIEAgYzS5jzIdRRLo+dcZQpMQeXR6HZyhrsCtzme/GZl7jwd/KsfKFKqecQMid+ENK5dImAFUbYN0RuWFeZ9Ssrd+KrEq0GcUQuy6+eJtJGaMoCrKcpQY+CZyexyvJ6fpkIlR/WhIZS/ZAzYVtc58mbJnf0KUhQB1FsKwb7kMp4SJuYAAACBAJinHd4YGS/a7fqA5KgrleZUqBnYPAsa12BduCv/P/3vQhEnY8rhaYOboWUxaTuo/ePnetOyuIz6kSISJG97b+oUFpx28pGXDcCcGQIgHnZkiSk0845LmzSqzjCMf75jf0+Ez6SxjUe+aOxXjIZXM9euA9nq7hdbpQ6Luh1j79Rd adeponte@andrew-de-pontes-macbook-pro.local")
end

When(/^I fill out the add public key form$/) do
  visit '/public_keys/new'
  fill_in 'public_key_name', with: 'test key name'
  fill_in 'public_key_value', with: 'ssh-dss AAAAB3NzaC1kc3MAAACBAKImSRgTHIEx61gZDYkj6QEpukwoiplXXv+D7lrOYCiRFuecQ2r5dhHTaNu8uGf79H5Tz83opBIwdqJCE3IMlINNj/tFmaDEdyeNtjkbk/9qmUDAgZ/FfCnU7SaGRZY2PslL3BhLYAZM2XNFaCKWb1mbCKJRCsCRLOqHxBIIXBm9AAAAFQDwKU42BMEnxK0dng2L4GdDTaP30wAAAIEAgYzS5jzIdRRLo+dcZQpMQeXR6HZyhrsCtzme/GZl7jwd/KsfKFKqecQMid+ENK5dImAFUbYN0RuWFeZ9Ssrd+KrEq0GcUQuy6+eJtJGaMoCrKcpQY+CZyexyvJ6fpkIlR/WhIZS/ZAzYVtc58mbJnf0KUhQB1FsKwb7kMp4SJuYAAACBAJinHd4YGS/a7fqA5KgrleZUqBnYPAsa12BduCv/P/3vQhEnY8rhaYOboWUxaTuo/ePnetOyuIz6kSISJG97b+oUFpx28pGXDcCcGQIgHnZkiSk0845LmzSqzjCMf75jf0+Ez6SxjUe+aOxXjIZXM9euA9nq7hdbpQ6Luh1j79Rd'
  click_button 'Add this Key'
end

Then(/^I should see public key I just added$/) do
  expect(page).to have_content('test key name')
  expect(page).to have_content('ssh-dss AAAAB3NzaC1kc3MAAACBAKImSRgTHIEx61gZDYkj6QEpukwoiplXXv+D7lrOYCiRFuecQ2r5dhHTaNu8uGf79H5Tz83opBIwdqJCE3IMlINNj/tFmaDEdyeNtjkbk/9qmUDAgZ/FfCnU7SaGRZY2PslL3BhLYAZM2XNFaCKWb1mbCKJRCsCRLOqHxBIIXBm9AAAAFQDwKU42BMEnxK0dng2L4GdDTaP30wAAAIEAgYzS5jzIdRRLo+dcZQpMQeXR6HZyhrsCtzme/GZl7jwd/KsfKFKqecQMid+ENK5dImAFUbYN0RuWFeZ9Ssrd+KrEq0GcUQuy6+eJtJGaMoCrKcpQY+CZyexyvJ6fpkIlR/WhIZS/ZAzYVtc58mbJnf0KUhQB1FsKwb7kMp4SJuYAAACBAJinHd4YGS/a7fqA5KgrleZUqBnYPAsa12BduCv/P/3vQhEnY8rhaYOboWUxaTuo/ePnetOyuIz6kSISJG97b+oUFpx28pGXDcCcGQIgHnZkiSk0845LmzSqzjCMf75jf0+Ez6SxjUe+aOxXjIZXM9euA9nq7hdbpQ6Luh1j79Rd')
end

When(/^I delete that key$/) do
  visit '/public_keys'
  click_link 'Delete'
end

Then(/^I should no longer see my public key$/) do
  expect(page).not_to have_content("my bar key")
  expect(page).not_to have_content("the actual bar key value")
end

When(/^I attempt to add an exploit public key$/) do
  visit '/public_keys/new'
  fill_in 'public_key_name', with: 'test exploit key name'
  fill_in 'public_key_value', with: "ssh-dss AAAAB3NzaC1kc3MAAACBAK\nssh-dss AAAAB3NzaC1kc3MAAACBAKImSRgTHIEx61gZDYkj6QEpukwoiplXXv+D7lrOYCiRFuecQ2r5dhHTaNu8uGf79H5Tz83opBIwdqJCE3IMlINNj/tFmaDEdyeNtjkbk/9qmUDAgZ/FfCnU7SaGRZY2PslL3BhLYAZM2XNFaCKWb1mbCKJRCsCRLOqHxBIIXBm9AAAAFQDwKU42BMEnxK0dng2L4GdDTaP30wAAAIEAgYzS5jzIdRRLo+dcZQpMQeXR6HZyhrsCtzme/GZl7jwd/KsfKFKqecQMid+ENK5dImAFUbYN0RuWFeZ9Ssrd+KrEq0GcUQuy6+eJtJGaMoCrKcpQY+CZyexyvJ6fpkIlR/WhIZS/ZAzYVtc58mbJnf0KUhQB1FsKwb7kMp4SJuYAAACBAJinHd4YGS/a7fqA5KgrleZUqBnYPAsa12BduCv/P/3vQhEnY8rhaYOboWUxaTuo/ePnetOyuIz6kSISJG97b+oUFpx28pGXDcCcGQIgHnZkiSk0845LmzSqzjCMf75jf0+Ez6SxjUe+aOxXjIZXM9euA9nq7hdbpQ6Luh1j79Rd"
  click_button 'Add this Key'
end

Then(/^I should see the invalid key message$/) do
  expect(page).to have_content("Invalid public key format.")
end

When(/^I attempt to import keys from github$/) do
  stub_request(:any, /api\.github\.com/).to_return(body: '[{"id": 34697, "key": "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA8BH++fTXcEZIjOCT1ZbE5HthApY+NnsVC/p9xZJJNV1U1bcKtc2mYAaHuRZtuq/KS3t7wjSPSlmNEfbgKDRWItOvqmGKO65IMJIhhWaa04fMy4kXP72LgdxSFGVE/SPXvf7XoVB7WI9FoaMXwE/RNGcx26jZnuFR4uXgeerpRM6M79+qpu0ch5bOa4zeP/iHR9ul188LIKc0HGqxfBtlz4MEpMVAf8bUGlEbEDp3l2qHoZgX7OcAaQDk/qnRDYU9qvHNacNkIW/j2M81OnjrVhOMj45cr6A5Ns/7eqN/QBR6vnWuXlLGAkx/isJZyR41KU0SpCVA2Xa+U2WHaV+QaQ==", "url": "https://api.github.com/user/keys/34697", "title": "Prometheus", "verified": true, "created_at": null}]')
  visit '/public_keys'
  click_link("Import Keys from Github")
end

Then(/^I should see the github key$/) do
  expect(page).to have_content("Prometheus")
end
