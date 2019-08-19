defmodule Okta do
  @moduledoc """
  This library provides an Elixir API for accessing the [Okta Developer APIs](https://developer.okta.com/docs/reference/).

  Currently implemented are:
  * [Users API](https://developer.okta.com/docs/reference/api/users/)
  * [Groups API](https://developer.okta.com/docs/reference/api/groups/)

  The API access uses the [Tesla](https://github.com/teamon/tesla) library and
  relies on the caller passing in an Okta base URL and an API Key to create a
  client. The client is then passed into all API calls.

  The API returns a 3 element tuple. If the API HTTP status code is less
  the 300 (ie. suceeded) it returns `:ok`, the HTTP body as a map and the full
  Tesla Env if you need to access more data about thre return. if the API HTTP
  status code is greater than 300. it returns `:error`, the HTTP body and the
  Telsa Env. If the API doesn't return at all it should return `:error`, a blank
   map and the error from Tesla.

      client = Okta.client("https://dev-000000.okta.com", "thisismykeycreatedinokta")

      profile = %{
        firstName: "test",
        lastName: "user",
      }

      case Okta.Users.create_user(client, profile) do
        {:ok, %{"id" => id, "status" => status}, _env} ->
          update_user(%{okta_id: id, okta_status: status})
        {:error, %{"errorSummary" => errorSummary}, _env} ->
          Logger.error(errorSummary)
      end

  ## Installation

  If [available in Hex](https://hex.pm/docs/publish), the package can be
  installed by adding `okta` to your list of dependencies in `mix.exs`:

      def deps do
        [
          {:okta_api, "~> 0.1.4"},
        ]
      end

  Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
  and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
  be found at [https://hexdocs.pm/okta](https://hexdocs.pm/okta_api).
  """
  @type client() :: Tesla.Client.t()
  @type result() :: {:ok, map(), Tesla.Env.t()} | {:error, map(), any}

  @spec client(String.t(), String.t()) :: client()
  def client(base_url, api_key) do
    middleware = [
      {Tesla.Middleware.BaseUrl, base_url},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"authorization", "SSWS " <> api_key}]}
    ]

    adapter =
      Application.get_env(:okta_api, :tesla)[:adapter] ||
        {Tesla.Adapter.Hackney, [recv_timeout: 30_000]}

    Tesla.client(middleware, adapter)
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
