require "spec_helper"

describe AuthorizedKeysGenerator do
  describe ".generate_and_write" do
    it "generates the new authorized_keys file content" do
      allow(subject).to receive(:write)
      expect(subject).to receive(:generate)
      subject.generate_and_write
    end

    it "writes the generated authorized_keys file content" do
      generated_auth_keys_content = double('generated authorized keys file content')
      allow(subject).to receive(:generate).and_return(generated_auth_keys_content)
      expect(subject).to receive(:write).with(generated_auth_keys_content)
      subject.generate_and_write
    end
  end

  describe ".generate" do
    it "gets all of the public keys" do
      expect(PublicKey).to receive(:all).and_return([])
      subject.generate
    end

    it "generates a proper authorized keys content" do
      PublicKey.create!(name: 'foo', value: 'ssh-dss AAAAB3NzaC1kc3MAAACBAKImSRgTHIEx61gZDYkj6QEpukwoiplXXv+D7lrOYCiRFuecQ2r5dhHTaNu8uGf79H5Tz83opBIwdqJCE3IMlINNj/tFmaDEdyeNtjkbk/9qmUDAgZ/FfCnU7SaGRZY2PslL3BhLYAZM2XNFaCKWb1mbCKJRCsCRLOqHxBIIXBm9AAAAFQDwKU42BMEnxK0dng2L4GdDTaP30wAAAIEAgYzS5jzIdRRLo+dcZQpMQeXR6HZyhrsCtzme/GZl7jwd/KsfKFKqecQMid+ENK5dImAFUbYN0RuWFeZ9Ssrd+KrEq0GcUQuy6+eJtJGaMoCrKcpQY+CZyexyvJ6fpkIlR/WhIZS/ZAzYVtc58mbJnf0KUhQB1FsKwb7kMp4SJuYAAACBAJinHd4YGS/a7fqA5KgrleZUqBnYPAsa12BduCv/P/3vQhEnY8rhaYOboWUxaTuo/ePnetOyuIz6kSISJG97b+oUFpx28pGXDcCcGQIgHnZkiSk0845LmzSqzjCMf75jf0+Ez6SxjUe+aOxXjIZXM9euA9nq7hdbpQ6Luh1j79Rd adeponte@andrew-de-pontes-macbook-pro.local')
      PublicKey.create!(name: 'bar', value: 'ssh-dss BAAAB3NzaC1kc3MAAACBAKImSRgTHIEx61gZDYkj6QEpukwoiplXXv+D7lrOYCiRFuecQ2r5dhHTaNu8uGf79H5Tz83opBIwdqJCE3IMlINNj/tFmaDEdyeNtjkbk/9qmUDAgZ/FfCnU7SaGRZY2PslL3BhLYAZM2XNFaCKWb1mbCKJRCsCRLOqHxBIIXBm9AAAAFQDwKU42BMEnxK0dng2L4GdDTaP30wAAAIEAgYzS5jzIdRRLo+dcZQpMQeXR6HZyhrsCtzme/GZl7jwd/KsfKFKqecQMid+ENK5dImAFUbYN0RuWFeZ9Ssrd+KrEq0GcUQuy6+eJtJGaMoCrKcpQY+CZyexyvJ6fpkIlR/WhIZS/ZAzYVtc58mbJnf0KUhQB1FsKwb7kMp4SJuYAAACBAJinHd4YGS/a7fqA5KgrleZUqBnYPAsa12BduCv/P/3vQhEnY8rhaYOboWUxaTuo/ePnetOyuIz6kSISJG97b+oUFpx28pGXDcCcGQIgHnZkiSk0845LmzSqzjCMf75jf0+Ez6SxjUe+aOxXjIZXM9euA9nq7hdbpQ6Luh1j79Rd adeponte@andrew-de-pontes-macbook-pro.local')
      expect(subject.generate).to eq(%q{no-pty,command="/bin/false" ssh-dss AAAAB3NzaC1kc3MAAACBAKImSRgTHIEx61gZDYkj6QEpukwoiplXXv+D7lrOYCiRFuecQ2r5dhHTaNu8uGf79H5Tz83opBIwdqJCE3IMlINNj/tFmaDEdyeNtjkbk/9qmUDAgZ/FfCnU7SaGRZY2PslL3BhLYAZM2XNFaCKWb1mbCKJRCsCRLOqHxBIIXBm9AAAAFQDwKU42BMEnxK0dng2L4GdDTaP30wAAAIEAgYzS5jzIdRRLo+dcZQpMQeXR6HZyhrsCtzme/GZl7jwd/KsfKFKqecQMid+ENK5dImAFUbYN0RuWFeZ9Ssrd+KrEq0GcUQuy6+eJtJGaMoCrKcpQY+CZyexyvJ6fpkIlR/WhIZS/ZAzYVtc58mbJnf0KUhQB1FsKwb7kMp4SJuYAAACBAJinHd4YGS/a7fqA5KgrleZUqBnYPAsa12BduCv/P/3vQhEnY8rhaYOboWUxaTuo/ePnetOyuIz6kSISJG97b+oUFpx28pGXDcCcGQIgHnZkiSk0845LmzSqzjCMf75jf0+Ez6SxjUe+aOxXjIZXM9euA9nq7hdbpQ6Luh1j79Rd adeponte@andrew-de-pontes-macbook-pro.local
no-pty,command="/bin/false" ssh-dss BAAAB3NzaC1kc3MAAACBAKImSRgTHIEx61gZDYkj6QEpukwoiplXXv+D7lrOYCiRFuecQ2r5dhHTaNu8uGf79H5Tz83opBIwdqJCE3IMlINNj/tFmaDEdyeNtjkbk/9qmUDAgZ/FfCnU7SaGRZY2PslL3BhLYAZM2XNFaCKWb1mbCKJRCsCRLOqHxBIIXBm9AAAAFQDwKU42BMEnxK0dng2L4GdDTaP30wAAAIEAgYzS5jzIdRRLo+dcZQpMQeXR6HZyhrsCtzme/GZl7jwd/KsfKFKqecQMid+ENK5dImAFUbYN0RuWFeZ9Ssrd+KrEq0GcUQuy6+eJtJGaMoCrKcpQY+CZyexyvJ6fpkIlR/WhIZS/ZAzYVtc58mbJnf0KUhQB1FsKwb7kMp4SJuYAAACBAJinHd4YGS/a7fqA5KgrleZUqBnYPAsa12BduCv/P/3vQhEnY8rhaYOboWUxaTuo/ePnetOyuIz6kSISJG97b+oUFpx28pGXDcCcGQIgHnZkiSk0845LmzSqzjCMf75jf0+Ez6SxjUe+aOxXjIZXM9euA9nq7hdbpQ6Luh1j79Rd adeponte@andrew-de-pontes-macbook-pro.local})
    end
  end

  describe ".write" do
    it "opens the configured authorized_keys file path" do
      expect(File).to receive(:open).with(AUTHORIZED_KEYS_CONFIG["authorized_keys_path"], 'w').and_return(double.as_null_object)
      subject.write("fooo content")
    end

    it "writes the given content to the authorized_keys file path" do
      file_obj_mock = double('authorized keys file object', close: nil)
      allow(File).to receive(:open).and_return(file_obj_mock)
      expect(file_obj_mock).to receive(:write).with("fooo content")
      subject.write("fooo content")
    end

    it "closes the authorized_keys file object" do
      file_obj_mock = double('authorized keys file object', write: nil)
      allow(File).to receive(:open).and_return(file_obj_mock)
      expect(file_obj_mock).to receive(:close)
      subject.write("fooo content")
    end
  end
end
