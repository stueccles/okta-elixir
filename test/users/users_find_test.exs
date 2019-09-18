defmodule Okta.UsersFindTest do
  use ExUnit.Case
  alias Okta.TestSupport.Helpers
  doctest Okta.Users

  setup do
    token = "ssws_token"
    user_id = "user123124"
    client = Okta.client(Helpers.base_url(), token)
    {:ok, %{client: client, token: token, user_id: user_id}}
  end

  test "get_current_user/1 requests correctly", %{client: client} do
    Helpers.mock_request(
      path: "/api/v1/users/me",
      method: :get,
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.get_current_user(client)
  end

  test "get_user/2 requests correctly", %{client: client, user_id: user_id} do
    Helpers.mock_request(
      path: "/api/v1/users/#{user_id}",
      method: :get,
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.get_user(client, user_id)
  end

  test "get_assigned_applinks/2 requests correctly", %{
    client: client,
    user_id: user_id
  } do
    Helpers.mock_request(
      path: "/api/v1/users/#{user_id}/appLinks",
      method: :get,
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.get_assigned_applinks(client, user_id)
  end

  test "get_groups_for_user/2 requests correctly", %{
    client: client,
    user_id: user_id
  } do
    Helpers.mock_request(
      path: "/api/v1/users/#{user_id}/groups",
      method: :get,
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.get_groups_for_user(client, user_id)
  end

  test "list_users/1 requests correctly", %{client: client} do
    Helpers.mock_request(
      path: "/api/v1/users",
      method: :get,
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.list_users(client)
  end

  test "list_users/2 requests correctly", %{client: client} do
    limit = 45

    Helpers.mock_request(
      path: "/api/v1/users",
      method: :get,
      query: [limit: limit],
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.list_users(client, limit: limit)
  end

  test "search_users/2 requests correctly", %{client: client} do
    search_term = "searching"

    Helpers.mock_request(
      path: "/api/v1/users",
      method: :get,
      query: [search: search_term],
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.search_users(client, search_term)
  end

  test "filter_users/2 requests correctly", %{client: client} do
    filter = "filter eq \"term\""

    Helpers.mock_request(
      path: "/api/v1/users",
      method: :get,
      query: [filter: filter],
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.filter_users(client, filter)
  end

  test "list_active_users/1 requests correctly", %{client: client} do
    filter = "status eq \"ACTIVE\""

    Helpers.mock_request(
      path: "/api/v1/users",
      method: :get,
      query: [filter: filter],
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.list_active_users(client)
  end

  test "list_staged_users/1 requests correctly", %{client: client} do
    filter = "status eq \"STAGED\""

    Helpers.mock_request(
      path: "/api/v1/users",
      method: :get,
      query: [filter: filter],
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.list_staged_users(client)
  end

  test "list_recovery_users/1 requests correctly", %{client: client} do
    filter = "status eq \"RECOVERY\""

    Helpers.mock_request(
      path: "/api/v1/users",
      method: :get,
      query: [filter: filter],
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.list_recovery_users(client)
  end

  test "list_deprovisioned_users/1 requests correctly", %{client: client} do
    filter = "status eq \"DEPROVISIONED\""

    Helpers.mock_request(
      path: "/api/v1/users",
      method: :get,
      query: [filter: filter],
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.list_deprovisioned_users(client)
  end

  test "list_password_expired_users/1 requests correctly", %{client: client} do
    filter = "status eq \"PASSWORD_EXPIRED\""

    Helpers.mock_request(
      path: "/api/v1/users",
      method: :get,
      query: [filter: filter],
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.list_password_expired_users(client)
  end

  test "list_provisioned_users/1 requests correctly", %{client: client} do
    filter = "status eq \"PROVISIONED\""

    Helpers.mock_request(
      path: "/api/v1/users",
      method: :get,
      query: [filter: filter],
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.list_provisioned_users(client)
  end

  test "list_locked_users/1 requests correctly", %{client: client} do
    filter = "status eq \"LOCKED_OUT\""

    Helpers.mock_request(
      path: "/api/v1/users",
      method: :get,
      query: [filter: filter],
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.list_locked_users(client)
  end

  test "list_users_updated_after/1 requests correctly", %{client: client} do
    now = DateTime.utc_now()

    filter = "status eq \"ACTIVE\" and lastUpdated gt \"#{DateTime.to_iso8601(now, :extended)}\""

    Helpers.mock_request(
      path: "/api/v1/users",
      method: :get,
      query: [filter: filter],
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.list_users_updated_after(client, now)
  end
end
