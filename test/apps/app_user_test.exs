defmodule Okta.AppUsersTest do
  use ExUnit.Case
  alias Okta.TestSupport.Helpers
  doctest Okta.Apps

  setup do
    token = "ssws_token"
    client = Okta.client(Helpers.base_url(), token)
    app_id = "345svbd235fasf"
    user_id = "dsfe45gdfsaf"

    credentials = %{
      userName: "user@example.com",
      password: %{
        value: "correcthorsebatterystaple"
      }
    }

    profile = %{role: "Developer", profile: "Standard User"}

    {:ok,
     %{
       client: client,
       user_id: user_id,
       app_id: app_id,
       credentials: credentials,
       profile: profile
     }}
  end

  test "assign_user_to_application/3  requests correctly", %{
    client: client,
    user_id: user_id,
    app_id: app_id
  } do
    Helpers.mock_request(
      path: "/api/v1/apps/#{app_id}/users",
      method: :post,
      body: Jason.encode!(%{id: user_id, scope: "USER", credentials: %{}, profile: %{}}),
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Apps.assign_user_to_application(client, app_id, user_id)
  end

  test "assign_user_to_application/5 requests correctly", %{
    client: client,
    user_id: user_id,
    app_id: app_id,
    credentials: credentials,
    profile: profile
  } do
    Helpers.mock_request(
      path: "/api/v1/apps/#{app_id}/users",
      method: :post,
      body:
        Jason.encode!(%{id: user_id, scope: "USER", credentials: credentials, profile: profile}),
      status: 200
    )

    assert {:ok, %{}, _env} =
             Okta.Apps.assign_user_to_application(client, app_id, user_id, credentials, profile)
  end

  test "get_user_for_application/3 requests correctly", %{
    client: client,
    user_id: user_id,
    app_id: app_id
  } do
    Helpers.mock_request(
      path: "/api/v1/apps/#{app_id}/users/#{user_id}",
      method: :get,
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Apps.get_user_for_application(client, app_id, user_id)
  end

  test "list_users_for_application/2 requests correctly", %{
    client: client,
    app_id: app_id
  } do
    Helpers.mock_request(
      path: "/api/v1/apps/#{app_id}/users",
      method: :get,
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Apps.list_users_for_application(client, app_id)
  end

  test "list_users_for_application/3 requests correctly", %{
    client: client,
    app_id: app_id
  } do
    Helpers.mock_request(
      path: "/api/v1/apps/#{app_id}/users",
      method: :get,
      query: [q: "query"],
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Apps.list_users_for_application(client, app_id, q: "query")
  end

  test "update_user_for_application/5 requests correctly", %{
    client: client,
    user_id: user_id,
    app_id: app_id,
    credentials: credentials,
    profile: profile
  } do
    Helpers.mock_request(
      path: "/api/v1/apps/#{app_id}/users/#{user_id}",
      method: :post,
      body: Jason.encode!(%{credentials: credentials, profile: profile}),
      status: 200
    )

    assert {:ok, %{}, _env} =
             Okta.Apps.update_user_for_application(client, app_id, user_id, credentials, profile)
  end

  test "update_user_for_application/5 requests correctly with just profile", %{
    client: client,
    user_id: user_id,
    app_id: app_id,
    profile: profile
  } do
    Helpers.mock_request(
      path: "/api/v1/apps/#{app_id}/users/#{user_id}",
      method: :post,
      body: Jason.encode!(%{profile: profile}),
      status: 200
    )

    assert {:ok, %{}, _env} =
             Okta.Apps.update_user_for_application(client, app_id, user_id, nil, profile)
  end

  test "update_user_for_application/5 requests correctly with just credentials", %{
    client: client,
    user_id: user_id,
    app_id: app_id,
    credentials: credentials
  } do
    Helpers.mock_request(
      path: "/api/v1/apps/#{app_id}/users/#{user_id}",
      method: :post,
      body: Jason.encode!(%{credentials: credentials}),
      status: 200
    )

    assert {:ok, %{}, _env} =
             Okta.Apps.update_user_for_application(client, app_id, user_id, credentials, nil)
  end

  test "remove_user_from_application/3 requests correctly", %{
    client: client,
    user_id: user_id,
    app_id: app_id
  } do
    Helpers.mock_request(
      path: "/api/v1/apps/#{app_id}/users/#{user_id}",
      method: :delete,
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Apps.remove_user_from_application(client, app_id, user_id)
  end
end
