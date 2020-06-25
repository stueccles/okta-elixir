defmodule Okta.OIDC do
  @moduledoc """
  The `Okta.OIDC` module provides access methods to the [Okta OpenID Connect & OAuth 2.0 API](https://developer.okta.com/docs/reference/api/oidc/).

  All methods require a Tesla Client struct created with `Okta.OIDC.client`.
  This client uses [client authentication](https://developer.okta.com/docs/reference/api/oidc/#client-authentication-methods) rather than Okta API token authentication.
  Currently the supported client authentication method is [Client Secret](https://developer.okta.com/docs/reference/api/oidc/#client-secret)

  ### `client_secret_basic`

      client = Okta.OIDC.oidc_client("https://dev-000000.okta.com", client_secret_basic: %{client_id: "thisistheclientid", client_secret: "thisistheclientsecret"})

  ### `client_secret_post`

      client = Okta.OIDC.oidc_client("https://dev-000000.okta.com", client_secret_post: %{client_id: "thisistheclientid", client_secret: "thisistheclientsecret"})

  ## Examples

      client = Okta.OIDC.oidc_client("https://dev-000000.okta.com", client_secret_basic: %{client_id: "thisistheclientid", client_secret: "thisistheclientsecret"})
      {:ok, result, _env} = Okta.OIDC.token_for_code(client,"thisisthecode", "https://localhost:8080/implicit/callback")

  """

  @doc """
  Returns access tokens, ID tokens, and refresh tokens, depending on the [request parameters](https://developer.okta.com/docs/reference/api/oidc/#request-parameters-2).
  Also takes `:auth_server_id` as an option to change the auth server from the standard "default"

  https://developer.okta.com/docs/reference/api/oidc/#token
  """
  @spec token(Okta.client(), map(), keyword()) :: Okta.result()
  def token(client, params, opts \\ []) do
    opts = Keyword.merge([auth_server_id: "default"], opts)

    Tesla.post(client, oidc_url(opts[:auth_server_id]) <> "/token", params)
    |> Okta.result()
    |> case do
      {ret, body, env} -> {ret, Jason.decode!(body), env}
      other -> other
    end
  end

  @doc """
  Returns access tokens, ID tokens, and refresh tokens given an `authorization_code` and `redirect_uri` used when creating the code on the `authorize` endpoint (usually in a browser)
  Also takes `:auth_server_id` as an option to change the auth server from the standard "default"

  https://developer.okta.com/docs/reference/api/oidc/#token
  """
  @spec token_for_code(Okta.client(), String.t(), String.t(), keyword()) :: Okta.result()
  def token_for_code(client, code, redirect__uri, opts \\ []) do
    params = %{grant_type: "authorization_code", redirect_uri: redirect__uri, code: code}
    token(client, params, opts)
  end

  @doc """
  Returns access tokens, ID tokens, and refresh tokens given a `refresh_cide` and `redirect_uri` used when the refresh_code was retrieved from the `token` endpoint
  Also takes `:auth_server_id` as an option to change the auth server from the standard "default" and an optional `:scope` argument, otherwise will default the scope to "offline_access openid"

  https://developer.okta.com/docs/reference/api/oidc/#token
  """
  @spec token_for_refresh_token(Okta.client(), String.t(), String.t(), keyword()) :: Okta.result()
  def token_for_refresh_token(client, refresh_token, redirect__uri, opts \\ []) do
    opts = Keyword.merge([scope: "offline_access openid"], opts)

    params = %{
      grant_type: "refresh_token",
      scope: opts[:scope],
      redirect_uri: redirect__uri,
      refresh_token: refresh_token
    }

    token(client, params, opts)
  end

  @doc """
  This endpoint takes an access, ID, or refresh token, and returns a boolean that indicates whether it is active or not. If the token is active, additional data about the token is also returned. If the token is invalid, expired, or revoked, it is considered inactive.
  Also takes `:auth_server_id` as an option to change the auth server from the standard "default" and an optional `:token_type_hint` argument to indicate what type of token it is

  https://developer.okta.com/docs/reference/api/oidc/#introspect
  """
  @spec token_for_refresh_token(Okta.client(), String.t(), keyword()) :: Okta.result()
  def introspect(client, token, opts \\ []) do
    opts = Keyword.merge([auth_server_id: "default", token_type_hint: nil], opts)

    Tesla.post(client, oidc_url(opts[:auth_server_id]) <> "/introspect", %{
      token: token,
      token_type_hint: opts[:token_type_hint]
    })
    |> Okta.result()
    |> case do
      {ret, body, env} -> {ret, Jason.decode!(body), env}
      other -> other
    end
  end

  @doc """
  The API takes an access or refresh token and revokes it. Revoked tokens are considered inactive at the introspection endpoint. A client may only revoke its own tokens
  Also takes `:auth_server_id` as an option to change the auth server from the standard "default" and an optional `:token_type_hint` argument to indicate what type of token it is

  https://developer.okta.com/docs/reference/api/oidc/#revoke
  """
  @spec revoke(Okta.client(), String.t(), keyword()) :: Okta.result()
  def revoke(client, token, opts \\ []) do
    opts = Keyword.merge([auth_server_id: "default", token_type_hint: nil], opts)

    Tesla.post(client, oidc_url(opts[:auth_server_id]) <> "/revoke", %{
      token: token,
      token_type_hint: opts[:token_type_hint]
    })
    |> Okta.result()
    |> case do
      {ret, body, env} -> {ret, Jason.decode!(body), env}
      other -> other
    end
  end

  @doc """
  Creates a Tesla Client struct specifically for OIDC API calls with [client authentication](https://developer.okta.com/docs/reference/api/oidc/#client-authentication-methods) rather than Okta API token authentication.
  Currently the supported client authentication method is [Client Secret](https://developer.okta.com/docs/reference/api/oidc/#client-secret)

  ### `client_secret_basic`

      client = Okta.OIDC.oidc_client("https://dev-000000.okta.com", client_secret_basic: %{client_id: "thisistheclientid", client_secret: "thisistheclientsecret"})

  ### `client_secret_post`

      client = Okta.OIDC.oidc_client("https://dev-000000.okta.com", client_secret_post: %{client_id: "thisistheclientid", client_secret: "thisistheclientsecret"})

  """
  @spec oidc_client(String.t(), keyword()) :: Okta.client()
  def oidc_client(base_url,
        client_secret_basic: %{client_id: client_id, client_secret: client_secret}
      ) do
    middleware = [
      {Tesla.Middleware.BaseUrl, base_url},
      Tesla.Middleware.FormUrlencoded,
      {Tesla.Middleware.Headers,
       [
         {"authorization", "Basic: " <> Base.encode64(client_id <> ":" <> client_secret)},
         {"accept", "application/json"},
         {"cache-control", "no-cache"}
       ]}
    ]

    Tesla.client(middleware, Okta.adapter())
  end

  def oidc_client(base_url,
        client_secret_post: %{client_id: client_id, client_secret: client_secret}
      ) do
    middleware = [
      {Tesla.Middleware.BaseUrl, base_url},
      {Tesla.Middleware.ClientSecretPost, [client_id: client_id, client_secret: client_secret]},
      Tesla.Middleware.FormUrlencoded,
      {Tesla.Middleware.Headers,
       [
         {"accept", "application/json"},
         {"cache-control", "no-cache"}
       ]}
    ]

    Tesla.client(middleware, Okta.adapter())
  end

  defp oidc_url(auth_server_id), do: "/oauth2/#{auth_server_id}/v1"
end

defmodule Tesla.Middleware.ClientSecretPost do
  @moduledoc false

  @behaviour Tesla.Middleware

  def call(%{body: body} = env, next, client_id: client_id, client_secret: client_secret) do
    env
    |> Tesla.put_body(Map.merge(body, %{client_id: client_id, client_secret: client_secret}))
    |> Tesla.run(next)
  end
end
