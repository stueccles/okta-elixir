defmodule Okta do
  @type client() :: Tesla.Client.t()
  @type result() :: {:ok, map(), Tesla.Env.t()} | {:error, map(), any}

  @spec client(String.t(), String.t()) :: client()
  def client(base_url, api_key) do
    middleware = [
      {Tesla.Middleware.BaseUrl, base_url},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"authorization", "SSWS " <> api_key}]}
    ]

    Tesla.client(middleware, Application.fetch_env!(:okta, :tesla)[:adapter])
  end

  @spec result({:ok, Tesla.Env.t()}) :: result()
  def result({:ok, %{status: status, body: body} = env}) when status < 300 do
    {:ok, body, env}
  end

  @spec result({:ok, Tesla.Env.t()}) :: result()
  def result({:ok, %{status: status, body: body} = env}) when status >= 300 do
    {:error, body, env}
  end

  @spec result({:error, any}) :: result()
  def result({:error, any}), do: {:error, %{}, any}
end
