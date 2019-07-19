defmodule Okta do
  @type client() :: Tesla.Client.t()

  @spec client(String.t(), String.t()) :: client()
  def client(base_url, api_key) do
    middleware = [
      {Tesla.Middleware.BaseUrl, base_url},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"authorization", "SSWS " <> api_key}]}
    ]

    Tesla.client(middleware, Application.fetch_env!(:okta, :tesla)[:adapter])
  end
end
