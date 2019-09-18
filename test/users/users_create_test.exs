defmodule Okta.UsersCreateTest do
  use ExUnit.Case
  alias Okta.TestSupport.Helpers
  doctest Okta.Users

  setup do
    token = "ssws_token"

    profile = %{
      firstName: "test",
      lastName: "user",
      login: "test@example.com",
      email: "test@example.com"
    }

    credentials = %{
      password: %{value: "password"}
    }

    provider_credentials = %{
      provider: %{type: "FEDERATION", name: "FEDERATION"}
    }

    group_ids = ["group1234123"]

    client = Okta.client(Helpers.base_url(), token)

    {:ok,
     %{
       client: client,
       token: token,
       profile: profile,
       credentials: credentials,
       provider_credentials: provider_credentials,
       group_ids: group_ids
     }}
  end

  test "create_user/2 with just profile requests correctly", %{
    client: client,
    profile: profile
  } do
    Helpers.mock_request(
      path: "/api/v1/users",
      method: :post,
      query: [activate: true],
      body: Jason.encode!(%{profile: profile}),
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.create_user(client, profile)
  end

  test "create_user/3 with activated profile requests correctly", %{
    client: client,
    profile: profile
  } do
    Helpers.mock_request(
      path: "/api/v1/users",
      method: :post,
      query: [activate: false],
      body: Jason.encode!(%{profile: profile}),
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.create_user(client, profile, false)
  end

  test "create_user/4 with activated profile and credentials requests correctly", %{
    client: client,
    profile: profile,
    credentials: credentials
  } do
    Helpers.mock_request(
      path: "/api/v1/users",
      method: :post,
      query: [activate: false],
      body: Jason.encode!(%{profile: profile, credentials: credentials}),
      status: 200
    )

    assert {:ok, %{}, _env} =
             Okta.Users.create_user(client, profile, false, credentials: credentials)
  end

  test "create_user/4 with activated profile, credentials, groupIds requests correctly", %{
    client: client,
    profile: profile,
    credentials: credentials,
    group_ids: group_ids
  } do
    Helpers.mock_request(
      path: "/api/v1/users",
      method: :post,
      query: [activate: false],
      body: Jason.encode!(%{profile: profile, credentials: credentials, groupIds: group_ids}),
      status: 200
    )

    assert {:ok, %{}, _env} =
             Okta.Users.create_user(client, profile, false,
               credentials: credentials,
               group_ids: group_ids
             )
  end

  test "create_user/4 with activated profile, credentials, groupIds and provider requests correctly",
       %{
         client: client,
         profile: profile,
         provider_credentials: credentials,
         group_ids: group_ids
       } do
    Helpers.mock_request(
      path: "/api/v1/users",
      method: :post,
      query: [provider: true, activate: false],
      body:
        Jason.encode!(%{
          profile: profile,
          credentials: credentials,
          groupIds: group_ids
        }),
      status: 200
    )

    assert {:ok, %{}, _env} =
             Okta.Users.create_user(client, profile, false,
               credentials: credentials,
               group_ids: group_ids,
               provider: true
             )
  end

  test "create_user/4 with activated profile, credentials, groupIds, provider and nextLogin change password requests correctly",
       %{
         client: client,
         profile: profile,
         provider_credentials: credentials,
         group_ids: group_ids
       } do
    Helpers.mock_request(
      path: "/api/v1/users",
      method: :post,
      query: [nextLogin: "changePassword", provider: true, activate: false],
      body:
        Jason.encode!(%{
          profile: profile,
          credentials: credentials,
          groupIds: group_ids
        }),
      status: 200
    )

    assert {:ok, %{}, _env} =
             Okta.Users.create_user(client, profile, false,
               credentials: credentials,
               group_ids: group_ids,
               provider: true,
               next_login: "changePassword"
             )
  end

  test "create_user_with_password/3 requests correctly", %{
    client: client,
    profile: profile
  } do
    password = "create_user_with_password"

    Helpers.mock_request(
      path: "/api/v1/users",
      method: :post,
      query: [activate: true],
      body: Jason.encode!(%{profile: profile, credentials: %{password: %{value: password}}}),
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.create_user_with_password(client, profile, password)
  end

  test "create_user_with_password/4 with activate requests correctly", %{
    client: client,
    profile: profile
  } do
    password = "create_user_with_password"

    Helpers.mock_request(
      path: "/api/v1/users",
      method: :post,
      query: [activate: false],
      body: Jason.encode!(%{profile: profile, credentials: %{password: %{value: password}}}),
      status: 200
    )

    assert {:ok, %{}, _env} =
             Okta.Users.create_user_with_password(client, profile, password, false)
  end

  test "create_user_with_provider/4 requests correctly", %{
    client: client,
    profile: profile
  } do
    provider_nametype = "SOCIAL"

    Helpers.mock_request(
      path: "/api/v1/users",
      method: :post,
      query: [provider: true, activate: true],
      body:
        Jason.encode!(%{
          profile: profile,
          credentials: %{provider: %{name: provider_nametype, type: provider_nametype}}
        }),
      status: 200
    )

    assert {:ok, %{}, _env} =
             Okta.Users.create_user_with_provider(
               client,
               profile,
               provider_nametype,
               provider_nametype
             )
  end

  test "update_user/4 requests correctly", %{
    client: client
  } do
    user_id = "123"
    data = %{profile: %{login: "newlogin@acmec.com"}}

    Helpers.mock_request(
      path: "/api/v1/users/#{user_id}",
      method: :put,
      query: [strict: true],
      body: Jason.encode!(data),
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.update_user(client, user_id, data, strict: true)
  end

  test "update_profile/4 requests correctly", %{
    client: client
  } do
    user_id = "123"
    data = %{profile: %{login: "newlogin@acmec.com"}}

    Helpers.mock_request(
      path: "/api/v1/users/#{user_id}",
      method: :post,
      query: [strict: true],
      body: Jason.encode!(data),
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.update_profile(client, user_id, data, strict: true)
  end
end
