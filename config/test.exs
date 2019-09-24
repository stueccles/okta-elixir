import Config

config :okta_api, :tesla, adapter: Okta.Tesla.Mock

config :plug, validate_header_keys_during_test: false
