require 'spec_helper'

describe PublicKey do
  context "when given an invalid public key value format" do
    it "returns a validity state of false" do
      pk = PublicKey.new(value: "AAAAB3NzaC1kc3MAAACBAKImSRgTHIEx61gZDYkj6QEpukwoiplXXv+D7lrOYCiRFuecQ2r5dhHTaNu8uGf79H5Tz83opBIwdqJCE3IMlINNj/tFmaDEdyeNtjkbk/9qmUDAgZ/FfCnU7SaGRZY2PslL3BhLYAZM2XNFaCKWb1mbCKJRCsCRLOqHxBIIXBm9AAAAFQDwKU42BMEnxK0dng2L4GdDTaP30wAAAIEAgYzS5jzIdRRLo+dcZQpMQeXR6HZyhrsCtzme/GZl7jwd/KsfKFKqecQMid+ENK5dImAFUbYN0RuWFeZ9Ssrd+KrEq0GcUQuy6+eJtJGaMoCrKcpQY+CZyexyvJ6fpkIlR/WhIZS/ZAzYVtc58mbJnf0KUhQB1FsKwb7kMp4SJuYAAACBAJinHd4YGS/a7fqA5KgrleZUqBnYPAsa12BduCv/P/3vQhEnY8rhaYOboWUxaTuo/ePnetOyuIz6kSISJG97b+oUFpx28pGXDcCcGQIgHnZkiSk0845LmzSqzjCMf75jf0+Ez6SxjUe+aOxXjIZXM9euA9nq7hdbpQ6Luh1j79Rd adeponte@andrew-de-pontes-macbook-pro.local")
      expect(pk.valid?).to be_false
    end
  end

  context "when given a valid public key value format" do
    it "returns a validity state of true" do
      pk = PublicKey.new(value: "ssh-dss AAAAB3NzaC1kc3MAAACBAKImSRgTHIEx61gZDYkj6QEpukwoiplXXv+D7lrOYCiRFuecQ2r5dhHTaNu8uGf79H5Tz83opBIwdqJCE3IMlINNj/tFmaDEdyeNtjkbk/9qmUDAgZ/FfCnU7SaGRZY2PslL3BhLYAZM2XNFaCKWb1mbCKJRCsCRLOqHxBIIXBm9AAAAFQDwKU42BMEnxK0dng2L4GdDTaP30wAAAIEAgYzS5jzIdRRLo+dcZQpMQeXR6HZyhrsCtzme/GZl7jwd/KsfKFKqecQMid+ENK5dImAFUbYN0RuWFeZ9Ssrd+KrEq0GcUQuy6+eJtJGaMoCrKcpQY+CZyexyvJ6fpkIlR/WhIZS/ZAzYVtc58mbJnf0KUhQB1FsKwb7kMp4SJuYAAACBAJinHd4YGS/a7fqA5KgrleZUqBnYPAsa12BduCv/P/3vQhEnY8rhaYOboWUxaTuo/ePnetOyuIz6kSISJG97b+oUFpx28pGXDcCcGQIgHnZkiSk0845LmzSqzjCMf75jf0+Ez6SxjUe+aOxXjIZXM9euA9nq7hdbpQ6Luh1j79Rd adeponte@andrew-de-pontes-macbook-pro.local")
      expect(pk.valid?).to be_true
    end
  end
end
