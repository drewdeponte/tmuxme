module AuthorizedKeysGenerator
  def self.generate_and_write
    write(generate)
  end

  def self.generate
    authorized_keys_content = []
    public_keys = PublicKey.all

    public_keys.each do |public_key|
      authorized_keys_content << public_key.value.strip
    end

    return authorized_keys_content.join("\n")
  end

  def self.write(content)
    f = File.open(AUTHORIZED_KEYS_CONFIG['authorized_keys_path'], 'w')
    f.write(content)
    f.close
  end
end
