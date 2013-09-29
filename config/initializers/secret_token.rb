# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
SECRET_TOKEN_CONFIG = YAML::load_file(File.join(File.dirname(__FILE__), '..', 'secret_token.yml'))[::Rails.env]
Tmuxme::Application.config.secret_key_base = SECRET_TOKEN_CONFIG['secret_key_base']
