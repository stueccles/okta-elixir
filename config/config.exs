import Config

config :okta, :tesla, adapter: {Tesla.Adapter.Hackney, [recv_timeout: 30_000]}

env_config = "#{Mix.env()}.exs"
File.exists?("config/#{env_config}") && import_config(env_config)
