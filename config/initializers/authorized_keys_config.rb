AUTHORIZED_KEYS_CONFIG = YAML::load_file(File.join(File.dirname(__FILE__), '..', 'authorized_keys.yml'))[::Rails.env]

require 'authorized_keys_generator'
