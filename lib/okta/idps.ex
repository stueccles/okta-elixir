defmodule Okta.IdPs do
  @moduledoc """
  The `Okta.IdPs` module provides access methods to the [Okta Identity Providers API](https://developer.okta.com/docs/reference/api/idps/).

  All methods require a Tesla Client struct created with `Okta.client(base_url, api_key)`.

  ## Examples

      client = Okta.Client("https://dev-000000.okta.com", "thisismykeycreatedinokta")
      {:ok, result, _env} = Okta.Users.list_idps(client)
  """

  alias Okta.IdPs.{IdentityProvider, Protocol, Policy}
  import Okta.Utils

  @idps_url "/api/v1/idps"

  @type single_result() :: {:ok, IdentityProvider.t(), Tesla.Env.t()} | {:error, map(), any}
  @type array_result() :: {:ok, list(IdentityProvider.t()), Tesla.Env.t()} | {:error, map(), any}

  @doc """
  Adds a new IdP to your organization

  The function requires an `Okta.Idps.IdentityProvider` with `type`, `name`, `protocol` and `policy` and returns a `Okta.Idps.IdentityProvider` in the second tuple position.

  https://developer.okta.com/docs/reference/api/idps/#add-identity-provider
  """
  @spec add_idp(Okta.client(), IdentityProvider.t()) :: single_result()
  def add_idp(client, %IdentityProvider{} = idp) do
    Tesla.post(client, @idps_url, transform_idp(idp)) |> Okta.result() |> idp_result()
  end

  @doc """
  Add Generic OpenID Connect Identity Provider

  The function requires a `name` and a `Okta.IdPs.Protocol` and `Okta.IdPs.Policy` and returns a `Okta.Idps.IdentityProvider` in the second tuple position.

  https://developer.okta.com/docs/reference/api/idps/#add-generic-openid-connect-identity-provider
  """
  @spec add_oidc_idp(Okta.client(), String.t(), Protocol.t(), Policy.t()) :: single_result()
  def add_oidc_idp(client, name, %Protocol{} = protocol, %Policy{} = policy) do
    idp = %IdentityProvider{name: name, type: "OIDC", protocol: protocol, policy: policy}
    add_idp(client, idp)
  end

  @doc """
  Get Identity Provider. Fetches an IdP by id

  This function returns a `Okta.Idps.IdentityProvider` in the second tuple position.

  https://developer.okta.com/docs/reference/api/idps/#get-identity-provider
  """
  @spec get_idp(Okta.client(), String.t()) :: single_result()
  def get_idp(client, idp_id) do
    Tesla.get(client, @idps_url <> "/#{idp_id}") |> Okta.result() |> idp_result()
  end

  @doc """
  List Identity Providers. Enumerates IdPs in your organization with pagination. A subset of IdPs can be returned that match a supported filter expression or query.

  This function returns an array of `Okta.Idps.IdentityProvider` in the second tuple position.

  https://developer.okta.com/docs/reference/api/idps/#list-identity-providers
  """
  @spec list_idps(Okta.client(), keyword()) :: array_result()
  def list_idps(client, opts \\ []) do
    Tesla.get(client, @idps_url, query: opts) |> Okta.result() |> idp_result()
  end

  @doc """
  Find Identity Providers by Name. Searches for IdPs by name in your organization

  This function returns an array of `Okta.Idps.IdentityProvider` in the second tuple position.

  https://developer.okta.com/docs/reference/api/idps/#find-identity-providers-by-name
  """
  @spec find_idps(Okta.client(), String.t(), keyword()) :: array_result()
  def find_idps(client, query, opts \\ []) do
    find_idps(client, Keyword.merge(opts, q: query))
  end

  @doc """
  Find Identity Providers by Type. Finds all IdPs with a specific type

  This function returns an array of `Okta.Idps.IdentityProvider` in the second tuple position.

  https://developer.okta.com/docs/reference/api/idps/#find-identity-providers-by-type
  """
  @spec find_idps_by_type(Okta.client(), String.t(), keyword()) :: array_result()
  def find_idps_by_type(client, type, opts \\ []) do
    find_idps(client, Keyword.merge(opts, type: type))
  end

  @doc """
  Updates the configuration for an IdP. All properties must be specified when updating IdP configuration. Partial updates are not supported by the Okta API

  The function requires an `Okta.Idps.IdentityProvider` with `type`, `name`, `issuerMode`, `status`, `protocol` and `policy` and returns a `Okta.Idps.IdentityProvider` in the second tuple position.

  https://developer.okta.com/docs/reference/api/idps/#update-identity-provider
  """
  @spec update_idp(Okta.client(), String.t(), IdentityProvider.t()) :: single_result()
  def update_idp(client, idp_id, %IdentityProvider{} = idp) do
    client
    |> Tesla.put(@idps_url <> "/#{idp_id}", transform_idp(idp))
    |> Okta.result()
    |> idp_result()
  end

  @doc """
  Will perform a partial update of an IdP with any supplied attributes and with partial protocol and policy.

  It works by first fetching the IdP data from the API and merging the supplied data with `Okta.Utils.merge_struct(struct1, struct2)`.
  This means concurrent updates *could* fail as this is not an atomic transaction.

  The function requires an `Okta.Idps.IdentityProvider` and returns a `Okta.Idps.IdentityProvider` in the second tuple position.

  https://developer.okta.com/docs/reference/api/idps/#update-identity-provider
  """
  @spec partial_update_idp(Okta.client(), String.t(), IdentityProvider.t()) :: single_result()
  def partial_update_idp(client, idp_id, %IdentityProvider{} = idp) do
    case get_idp(client, idp_id) do
      {:ok, old_idp, _env} -> update_idp(client, idp_id, merge_struct(old_idp, idp))
      res -> res
    end
  end

  @doc """
  Delete Identity Provider. Removes an IdP from your organization.

  https://developer.okta.com/docs/reference/api/idps/#delete-identity-provider
  """
  @spec delete_idp(Okta.client(), String.t()) :: Okta.result()
  def delete_idp(client, idp_id) do
    Tesla.delete(client, @idps_url <> "/#{idp_id}") |> Okta.result()
  end

  @doc """
  Activate Identity Provider. Activates an inactive IdP.

  This function returns a `Okta.Idps.IdentityProvider` in the second tuple position.

  https://developer.okta.com/docs/reference/api/idps/#activate-identity-provider
  """
  @spec activate_idp(Okta.client(), String.t()) :: single_result()
  def activate_idp(client, idp_id) do
    Tesla.post(client, @idps_url <> "/#{idp_id}/lifecycle/activate", %{})
    |> Okta.result()
    |> idp_result()
  end

  @doc """
  Deactivate Identity Provider. Deactivates an active IdP

    This function returns a `Okta.Idps.IdentityProvider` in the second tuple position.

  https://developer.okta.com/docs/reference/api/idps/#deactivate-identity-provider
  """
  @spec deactivate_idp(Okta.client(), String.t()) :: single_result()
  def deactivate_idp(client, idp_id) do
    Tesla.post(client, @idps_url <> "/#{idp_id}/lifecycle/deactivate", %{})
    |> Okta.result()
    |> idp_result()
  end

  @doc """
  Find Users. Find all the users linked to an identity provider.

  https://developer.okta.com/docs/reference/api/idps/#find-users
  """
  @spec find_users(Okta.client(), String.t()) :: Okta.result()
  def find_users(client, idp_id) do
    Tesla.get(client, @idps_url <> "/#{idp_id}/users") |> Okta.result()
  end

  @doc """
  Get a Linked Identity Provider User. Fetches a linked IdP user by ID.

  https://developer.okta.com/docs/reference/api/idps/#get-a-linked-identity-provider-user
  """
  @spec get_linked_user(Okta.client(), String.t(), String.t()) :: Okta.result()
  def get_linked_user(client, idp_id, user_id) do
    Tesla.get(client, @idps_url <> "/#{idp_id}/users/#{user_id}") |> Okta.result()
  end

  @doc """
  Social Authentication Token Operation.

  Okta doesn't import all the user information from a social provider.
  If the app needs information which isn't imported, it can get the user token from this endpoint, then make an API call to the social provider with the token to request the additional information.

  https://developer.okta.com/docs/reference/api/idps/#social-authentication-token-operation
  """
  @spec social_tokens(Okta.client(), String.t(), String.t()) :: Okta.result()
  def social_tokens(client, idp_id, user_id) do
    Tesla.get(client, @idps_url <> "/#{idp_id}/users/#{user_id}/credentials/tokens")
    |> Okta.result()
  end

  @doc """
  Link a User to a Social Provider without a Transaction.

  Links an Okta user to an existing social provider. This endpoint doesn't support the SAML2 Identity Provider Type.

  https://developer.okta.com/docs/reference/api/idps/#link-a-user-to-a-social-provider-without-a-transaction
  """
  @spec link_user(Okta.client(), String.t(), String.t(), String.t()) :: Okta.result()
  def link_user(client, idp_id, user_id, external_id) do
    Tesla.post(client, @idps_url <> "/#{idp_id}/users/#{user_id}", %{externalId: external_id})
    |> Okta.result()
  end

  @doc """
  Unlink User from IdP

  Removes the link between the Okta user and the IdP user.
  The next time the user federates into Okta via this IdP, they have to re-link their account according to the account link policy configured in Okta for this IdP.

  https://developer.okta.com/docs/reference/api/idps/#unlink-user-from-idp
  """
  @spec unlink_user(Okta.client(), String.t(), String.t()) :: Okta.result()
  def unlink_user(client, idp_id, user_id) do
    Tesla.delete(client, @idps_url <> "/#{idp_id}/users/#{user_id}") |> Okta.result()
  end

  defp transform_idp(%IdentityProvider{} = idp) do
    idp
    |> Map.from_struct()
    |> Map.take([:type, :issuerMode, :name, :protocol, :policy, :status])
    |> stringify_keys()
  end

  defp idp_result({:ok, idps, env}) when is_list(idps),
    do: {:ok, Enum.map(idps, &parse_idp_return/1), env}

  defp idp_result({:ok, idp, env}), do: {:ok, parse_idp_return(idp), env}
  defp idp_result(result), do: result

  defp parse_idp_return(idp_data) do
    policy = to_struct(Policy, idp_data["policy"])
    protocol = to_struct(Protocol, idp_data["protocol"])

    IdentityProvider
    |> to_struct(idp_data)
    |> Map.put(:policy, policy)
    |> Map.put(:protocol, protocol)
  end
end
