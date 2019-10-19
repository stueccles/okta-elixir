defmodule Okta.TrustedOrigins do
  @moduledoc """
  The `Okta.TrustedOrigins` module provides access methods to the [Okta Trusted Origins API](https://developer.okta.com/docs/reference/api/trusted-origins/).

  All methods require a Tesla Client struct created with `Okta.client(base_url, api_key)`.

  ## Examples

      client = Okta.Client("https://dev-000000.okta.com", "thisismykeycreatedinokta")
      {:ok, result, _env} = Okta.TrustedOrigins.list_trusted_origins(client)

  """

  @trusted_origins_api "/api/v1/trustedOrigins"

  @doc """
  Creates a new trusted origin

  The scopes parameter is a List with one or both of `:cors` and `:redirect`

  ## Examples
  ```
      client = Okta.Client("https://dev-000000.okta.com", "thisismykeycreatedinokta")
      {:ok, result, _env} = Okta.TrustedOrigins.create_trusted_origin(client, "Test", "https://example.com/test", [:cors, :redirect])
  ```
  https://developer.okta.com/docs/reference/api/trusted-origins/#create-trusted-origin
  """
  @spec create_trusted_origin(Okta.client(), String.t(), String.t(), [:cors | :redirect]) ::
          Okta.result()
  def create_trusted_origin(client, name, origin, scopes) do
    Tesla.post(client, @trusted_origins_api, trusted_origin_body(name, origin, scopes))
    |> Okta.result()
  end

  @doc """
  Gets a trusted origin by ID

  ## Examples
  ```
      client = Okta.Client("https://dev-000000.okta.com", "thisismykeycreatedinokta")
      {:ok, result, _env} = Okta.TrustedOrigins.get_trusted_origin(client, "tosue7JvguwJ7U6kz0g3")
  ```
  https://developer.okta.com/docs/reference/api/trusted-origins/#get-trusted-origin
  """
  @spec get_trusted_origin(Okta.client(), String.t()) :: Okta.result()
  def get_trusted_origin(client, trusted_origin_id) do
    Tesla.get(client, @trusted_origins_api <> "/#{trusted_origin_id}") |> Okta.result()
  end

  @doc """
  Lists all trusted origins

  A subset of trusted origins can be returned that match a supported filter expression or query criteria.

  ## Examples
  ```
      client = Okta.Client("https://dev-000000.okta.com", "thisismykeycreatedinokta")
      {:ok, result, _env} = Okta.TrustedOrigins.list_trusted_origins(client, limit: 1000)
  ```
  https://developer.okta.com/docs/reference/api/trusted-origins/#list-trusted-origins
  """
  @spec list_trusted_origins(Okta.client(), keyword()) :: Okta.result()
  def list_trusted_origins(client, opts \\ []) do
    Tesla.get(client, @trusted_origins_api, query: opts) |> Okta.result()
  end

  @doc """
  Lists all trusted origins with a filter

  ## Examples
  ```
      client = Okta.Client("https://dev-000000.okta.com", "thisismykeycreatedinokta")
      {:ok, result, _env} = Okta.TrustedOrigins.filter_trusted_origins(client, "(id eq \"tosue7JvguwJ7U6kz0g3\" or id eq \"tos10hzarOl8zfPM80g4\")")
  ```
  https://developer.okta.com/docs/reference/api/trusted-origins/#list-trusted-origins-with-a-filter
  """
  @spec filter_trusted_origins(Okta.client(), String.t(), keyword()) :: Okta.result()
  def filter_trusted_origins(client, filter, opts \\ []) do
    list_trusted_origins(client, Keyword.merge(opts, filter: filter))
  end

  @doc """
  Updates a trusted origin

  The scopes parameter is a List with one or both of `:cors` and `:redirect`

  ## Examples
  ```
      client = Okta.Client("https://dev-000000.okta.com", "thisismykeycreatedinokta")
      {:ok, result, _env} = Okta.TrustedOrigins.update_trusted_origin(client, "tosue7JvguwJ7U6kz0g3", "Test", "https://example.com/test", [:cors, :redirect])
  ```
  https://developer.okta.com/docs/reference/api/trusted-origins/#update-trusted-origin
  """
  @spec update_trusted_origin(Okta.client(), String.t(), String.t(), String.t(), [
          :cors | :redirect
        ]) ::
          Okta.result()
  def update_trusted_origin(client, trusted_origin_id, name, origin, scopes) do
    Tesla.put(
      client,
      @trusted_origins_api <> "/#{trusted_origin_id}",
      trusted_origin_body(name, origin, scopes)
    )
    |> Okta.result()
  end

  @doc """
  Activates an existing trusted origin

  ## Examples
  ```
      client = Okta.Client("https://dev-000000.okta.com", "thisismykeycreatedinokta")
      {:ok, result, _env} = Okta.TrustedOrigins.activate_trusted_origin(client, "tosue7JvguwJ7U6kz0g3")
  ```
  https://developer.okta.com/docs/reference/api/trusted-origins/#activate-trusted-origin
  """
  @spec activate_trusted_origin(Okta.client(), String.t()) :: Okta.result()
  def activate_trusted_origin(client, trusted_origin_id) do
    Tesla.post(client, @trusted_origins_api <> "/#{trusted_origin_id}/lifecycle/activate", %{})
    |> Okta.result()
  end

  @doc """
  Deactivates an existing trusted origin

  ## Examples
  ```
      client = Okta.Client("https://dev-000000.okta.com", "thisismykeycreatedinokta")
      {:ok, result, _env} = Okta.TrustedOrigins.deactivate_trusted_origin(client, "tosue7JvguwJ7U6kz0g3")
  ```
  https://developer.okta.com/docs/reference/api/trusted-origins/#deactivate-trusted-origin
  """
  @spec deactivate_trusted_origin(Okta.client(), String.t()) :: Okta.result()
  def deactivate_trusted_origin(client, trusted_origin_id) do
    Tesla.post(client, @trusted_origins_api <> "/#{trusted_origin_id}/lifecycle/deactivate", %{})
    |> Okta.result()
  end

  @doc """
  Deletes an existing trusted origin

  ## Examples
  ```
      client = Okta.Client("https://dev-000000.okta.com", "thisismykeycreatedinokta")
      {:ok, result, _env} = Okta.TrustedOrigins.delete_trusted_origin(client, "tosue7JvguwJ7U6kz0g3")
  ```
  https://developer.okta.com/docs/reference/api/trusted-origins/#delete-trusted-origin
  """
  @spec delete_trusted_origin(Okta.client(), String.t()) :: Okta.result()
  def delete_trusted_origin(client, trusted_origin_id) do
    Tesla.delete(client, @trusted_origins_api <> "/#{trusted_origin_id}")
    |> Okta.result()
  end

  defp trusted_origin_body(name, origin, scopes) do
    scopes =
      Enum.reduce(scopes, [], fn scope, new_scopes ->
        case scope do
          :cors -> [%{type: "CORS"} | new_scopes]
          :redirect -> [%{type: "REDIRECT"} | new_scopes]
          _ -> new_scopes
        end
      end)

    %{
      name: name,
      origin: origin,
      scopes: scopes
    }
  end
end
