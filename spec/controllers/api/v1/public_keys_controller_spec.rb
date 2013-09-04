require 'spec_helper'

describe Api::V1::PublicKeysController do
  describe "GET index" do
    context "when can't find user" do
      it "responds with a 404 not found" do
        get :index, :user_id => 'bob'
        expect(response.status).to eq(404)
      end
    end

    context "when can find user" do
      context "when the user has no public keys" do
        it "renders an empty JSON array" do
          user = User.create!(:username => 'someuser', :email => 'someuser@example.com', :password => 'bluepork', :password_confirmation => 'bluepork')
          get :index, :user_id => 'bob'
          expect(response.body).to eq('[]')
        end
      end

      context "when the user has a public key" do
        it "runders a JSON array of the public key values" do
          user = User.create!(:username => 'someuser', :email => 'someuser@example.com', :password => 'bluepork', :password_confirmation => 'bluepork')
          user.public_keys.create!(name: 'foo key', value: 'ssh-dss AAAAB3NzaC1kc3MAAACBAKImSRgTHIEx61gZDYkj6QEpukwoiplXXv+D7lrOYCiRFuecQ2r5dhHTaNu8uGf79H5Tz83opBIwdqJCE3IMlINNj/tFmaDEdyeNtjkbk/9qmUDAgZ/FfCnU7SaGRZY2PslL3BhLYAZM2XNFaCKWb1mbCKJRCsCRLOqHxBIIXBm9AAAAFQDwKU42BMEnxK0dng2L4GdDTaP30wAAAIEAgYzS5jzIdRRLo+dcZQpMQeXR6HZyhrsCtzme/GZl7jwd/KsfKFKqecQMid+ENK5dImAFUbYN0RuWFeZ9Ssrd+KrEq0GcUQuy6+eJtJGaMoCrKcpQY+CZyexyvJ6fpkIlR/WhIZS/ZAzYVtc58mbJnf0KUhQB1FsKwb7kMp4SJuYAAACBAJinHd4YGS/a7fqA5KgrleZUqBnYPAsa12BduCv/P/3vQhEnY8rhaYOboWUxaTuo/ePnetOyuIz6kSISJG97b+oUFpx28pGXDcCcGQIgHnZkiSk0845LmzSqzjCMf75jf0+Ez6SxjUe+aOxXjIZXM9euA9nq7hdbpQ6Luh1j79Rd adeponte@andrew-de-pontes-macbook-pro.local')
          user.public_keys.create!(name: 'bar key', value: 'ssh-dss AAAAB3NzaC1kc3MAAACBAKImSRgTHIEx61gZDYkj6QEpukwoiplXXv+D7lrOYCiRFuecQ2r5dhHTaNu8uGf79H5Tz83opBIwdqJCE3IMlINNj/tFmaDEdyeNtjkbk/9qmUDAgZ/FfCnU7SaGRZY2PslL3BhLYAZM2XNFaCKWb1mbCKJRCsCRLOqHxBIIXBm9AAAAFQDwKU42BMEnxK0dng2L4GdDTaP30wAAAIEAgYzS5jzIdRRLo+dcZQpMQeXR6HZyhrsCtzme/GZl7jwd/KsfKFKqecQMid+ENK5dImAFUbYN0RuWFeZ9Ssrd+KrEq0GcUQuy6+eJtJGaMoCrKcpQY+CZyexyvJ6fpkIlR/WhIZS/ZAzYVtc58mbJnf0KUhQB1FsKwb7kMp4SJuYAAACBAJinHd4YGS/a7fqA5KgrleZUqBnYPAsa12BduCv/P/3vQhEnY8rhaYOboWUxaTuo/ePnetOyuIz6kSISJG97b+oUFpx28pGXDcCcGQIgHnZkiSk0845LmzSqzjCMf75jf0+Ez6SxjUe+aOxXjIZXM9euA9nq7hdbpQ6Luh1j79Rd')
          get :index, :user_id => 'someuser'
          expect(response.body).to eq("[\"ssh-dss AAAAB3NzaC1kc3MAAACBAKImSRgTHIEx61gZDYkj6QEpukwoiplXXv+D7lrOYCiRFuecQ2r5dhHTaNu8uGf79H5Tz83opBIwdqJCE3IMlINNj/tFmaDEdyeNtjkbk/9qmUDAgZ/FfCnU7SaGRZY2PslL3BhLYAZM2XNFaCKWb1mbCKJRCsCRLOqHxBIIXBm9AAAAFQDwKU42BMEnxK0dng2L4GdDTaP30wAAAIEAgYzS5jzIdRRLo+dcZQpMQeXR6HZyhrsCtzme/GZl7jwd/KsfKFKqecQMid+ENK5dImAFUbYN0RuWFeZ9Ssrd+KrEq0GcUQuy6+eJtJGaMoCrKcpQY+CZyexyvJ6fpkIlR/WhIZS/ZAzYVtc58mbJnf0KUhQB1FsKwb7kMp4SJuYAAACBAJinHd4YGS/a7fqA5KgrleZUqBnYPAsa12BduCv/P/3vQhEnY8rhaYOboWUxaTuo/ePnetOyuIz6kSISJG97b+oUFpx28pGXDcCcGQIgHnZkiSk0845LmzSqzjCMf75jf0+Ez6SxjUe+aOxXjIZXM9euA9nq7hdbpQ6Luh1j79Rd adeponte@andrew-de-pontes-macbook-pro.local\",\"ssh-dss AAAAB3NzaC1kc3MAAACBAKImSRgTHIEx61gZDYkj6QEpukwoiplXXv+D7lrOYCiRFuecQ2r5dhHTaNu8uGf79H5Tz83opBIwdqJCE3IMlINNj/tFmaDEdyeNtjkbk/9qmUDAgZ/FfCnU7SaGRZY2PslL3BhLYAZM2XNFaCKWb1mbCKJRCsCRLOqHxBIIXBm9AAAAFQDwKU42BMEnxK0dng2L4GdDTaP30wAAAIEAgYzS5jzIdRRLo+dcZQpMQeXR6HZyhrsCtzme/GZl7jwd/KsfKFKqecQMid+ENK5dImAFUbYN0RuWFeZ9Ssrd+KrEq0GcUQuy6+eJtJGaMoCrKcpQY+CZyexyvJ6fpkIlR/WhIZS/ZAzYVtc58mbJnf0KUhQB1FsKwb7kMp4SJuYAAACBAJinHd4YGS/a7fqA5KgrleZUqBnYPAsa12BduCv/P/3vQhEnY8rhaYOboWUxaTuo/ePnetOyuIz6kSISJG97b+oUFpx28pGXDcCcGQIgHnZkiSk0845LmzSqzjCMf75jf0+Ez6SxjUe+aOxXjIZXM9euA9nq7hdbpQ6Luh1j79Rd\"]")
        end
      end
    end
  end
end
