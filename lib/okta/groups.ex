defmodule Okta.Groups do
  @moduledoc """
  The `Okta.Groups` module provides access methods to the [Okta Groups API](https://developer.okta.com/docs/reference/api/groups/).

  All methods require a Tesla Client struct created with `Okta.client(base_url, api_key)`.

  ## Examples

      client = Okta.Client("https://dev-000000.okta.com", "thisismykeycreatedinokta")
      {:ok, result, _env} = Okta.Groups.list_groups(client)

  """

  @groups_url "/api/v1/groups"

  @doc """
  Adds a new group with OKTA_GROUP type to your organization.

  The [OKTA group profile object](https://developer.okta.com/docs/reference/api/groups/#objectclass-okta-user-group)
  has a name and description attributes.

  ## Examples


      client = Okta.Client("https://dev-000000.okta.com", "thisismykeycreatedinokta")
      {:ok, result} = Okta.Groups.create_group(client, %{
        name: "Designers", description: "All the designers"
      })

  https://developer.okta.com/docs/reference/api/groups/#add-group
  """
  @spec create_group(Okta.client(), map()) :: Okta.result()
  def create_group(client, profile) do
    Tesla.post(client, @groups_url, %{profile: profile}) |> Okta.result()
  end

  @doc """
  Updates the profile for a group with OKTA_GROUP type from your organization.
  The [OKTA group profile object](https://developer.okta.com/docs/reference/api/groups/#objectclass-okta-user-group)
  has a name and description attributes.

  https://developer.okta.com/docs/reference/api/groups/#update-group
  """
  @spec update_group(Okta.client(), String.t(), map()) :: Okta.result()
  def update_group(client, group_id, profile) do
    Tesla.put(client, @groups_url <> "/#{group_id}", %{profile: profile}) |> Okta.result()
  end

  @doc """
  Removes a group with OKTA_GROUP type from your organization.

  https://developer.okta.com/docs/reference/api/groups/#remove-group
  """
  @spec delete_group(Okta.client(), String.t()) :: Okta.result()
  def delete_group(client, group_id) do
    Tesla.delete(client, @groups_url <> "/#{group_id}") |> Okta.result()
  end

  @doc """
  Fetches a specific group by id from your organization.

  https://developer.okta.com/docs/reference/api/groups/#get-group
  """
  @spec get_group(Okta.client(), String.t()) :: Okta.result()
  def get_group(client, group_id) do
    Tesla.get(client, @groups_url <> "/#{group_id}") |> Okta.result()
  end

  @doc """
  Enumerates all users that are a member of a group. `limit` and `after`
  parameters provide for paging.

  https://developer.okta.com/docs/reference/api/groups/#list-group-members
  """
  @spec list_group_members(Okta.client(), String.t()) :: Okta.result()
  def list_group_members(client, group_id, opt \\ []) do
    Tesla.get(client, @groups_url <> "/#{group_id}/users", query: opt) |> Okta.result()
  end

  @doc """
  Enumerates all applications that are assigned to a group.

  https://developer.okta.com/docs/reference/api/groups/#list-assigned-applications
  """
  @spec list_group_apps(Okta.client(), String.t()) :: Okta.result()
  def list_group_apps(client, group_id, opt \\ []) do
    Tesla.get(client, @groups_url <> "/#{group_id}/apps", query: opt) |> Okta.result()
  end

  @doc """
  Removes a user from a group with OKTA_GROUP type.

  https://developer.okta.com/docs/reference/api/groups/#remove-user-from-group
  """
  @spec remove_user_from_group(Okta.client(), String.t(), String.t()) :: Okta.result()
  def remove_user_from_group(client, group_id, user_id) do
    Tesla.delete(client, @groups_url <> "/#{group_id}/users/#{user_id}") |> Okta.result()
  end

  @doc """
  Adds a user to a group with OKTA_GROUP type.

  https://developer.okta.com/docs/reference/api/groups/#add-user-to-group
  """
  @spec add_user_to_group(Okta.client(), String.t(), String.t()) :: Okta.result()
  def add_user_to_group(client, group_id, user_id) do
    Tesla.put(client, @groups_url <> "/#{group_id}/users/#{user_id}", "") |> Okta.result()
  end

  @doc """
  Enumerates groups in your organization with pagination.

  A subset of groups can be returned that match a supported filter expression or
  query.

  See https://developer.okta.com/docs/reference/api/groups/#list-groups for
  optional parameters that can be passed in.

  ##Example

      {:ok, result} = Okta.Users.list_groups(client, q: "Design", limit: 10, after: 200)
  """
  @spec list_groups(Okta.client(), keyword()) :: Okta.result()
  def list_groups(client, opts \\ []) do
    Tesla.get(client, @groups_url, query: opts) |> Okta.result()
  end

  @doc """
  Searches for groups by name in your organization.

  https://developer.okta.com/docs/reference/api/groups/#search-groups
  """
  @spec search_groups(Okta.client(), String.t(), keyword()) :: Okta.result()
  def search_groups(client, name, opts \\ []) do
    list_groups(client, Keyword.merge(opts, q: name))
  end

  @doc """
  Filter groups by expression.

  See https://developer.okta.com/docs/reference/api/groups/#list-groups and
  https://developer.okta.com/docs/reference/api-overview/#filtering

  """
  @spec filter_groups(Okta.client(), String.t(), keyword()) :: Okta.result()
  def filter_groups(client, filter, opts \\ []) do
    list_groups(client, Keyword.merge(opts, filter: filter))
  end

  @doc """
  Enumerates all groups with a specific type.

  https://developer.okta.com/docs/reference/api/groups/#list-groups-with-type
  """
  @spec list_groups_of_type(Okta.client(), String.t(), keyword()) :: Okta.result()
  def list_groups_of_type(client, type, opts \\ []) do
    filter_groups(client, "type eq \"#{type}\"", opts)
  end

  @doc """
  Enumerates all groups with a profile updated after the specified timestamp.

  https://developer.okta.com/docs/reference/api/groups/#list-groups-with-profile-updated-after-timestamp
  """
  @spec list_groups_profile_updated_after(Okta.client(), Calendar.datetime(), keyword()) :: Okta.result()
  def list_groups_profile_updated_after(client, updated_at, opts \\ []) do
    filter_groups(
      client,
      "lastUpdated gt \"#{DateTime.to_iso8601(updated_at, :extended)}\"",
      opts
    )
  end

  @doc """
  Enumerates all groups with user memberships updated after the specified
  timestamp.

  https://developer.okta.com/docs/reference/api/groups/#list-groups-with-membership-updated-after-timestamp
  """
  @spec list_groups_membership_updated_after(Okta.client(), Calendar.datetime(), keyword()) :: Okta.result()
  def list_groups_membership_updated_after(client, updated_at, opts \\ []) do
    filter_groups(
      client,
      "lastMembershipUpdated gt \"#{DateTime.to_iso8601(updated_at, :extended)}\"",
      opts
    )
  end

  @doc """
  Enumerates all groups with profile or user memberships updated after the
  specified timestamp.

  https://developer.okta.com/docs/reference/api/groups/#list-groups-updated-after-timestamp
  """
  @spec list_groups_updated_after(Okta.client(), Calendar.datetime(), keyword()) :: Okta.result()
  def list_groups_updated_after(client, updated_at, opts \\ []) do
    filter_groups(
      client,
      "lastUpdated gt \"#{DateTime.to_iso8601(updated_at, :extended)}\" or lastMembershipUpdated gt \"#{
        DateTime.to_iso8601(updated_at, :extended)
      }\"",
      opts
    )
  end
end
