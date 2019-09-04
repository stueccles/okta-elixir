defmodule Okta.UsersCreateTest do
  use ExUnit.Case
  doctest Okta.Users

  setup do
    base_url = "https://dev-000000.okta.com"
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

    client = Okta.client(base_url, token)

    {:ok,
     %{
       client: client,
       base_url: base_url,
       token: token,
       profile: profile,
       credentials: credentials,
       provider_credentials: provider_credentials,
       group_ids: group_ids
     }}
  end

  test "create_user/2 with just profile requests correctly", %{
    client: client,
    base_url: base_url,
    profile: profile
  } do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        {:ok, expected_body} = Jason.encode(%{profile: profile})
        assert expected_body == request.body
        assert :post == request.method
        assert [activate: true] = request.query
        assert "#{base_url}/api/v1/users" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, %{}, _env} = Okta.Users.create_user(client, profile)
  end

  test "create_user/3 with activated profile requests correctly", %{
    client: client,
    base_url: base_url,
    profile: profile
  } do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        {:ok, expected_body} = Jason.encode(%{profile: profile})
        assert expected_body == request.body
        assert :post == request.method
        assert [activate: false] = request.query
        assert "#{base_url}/api/v1/users" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, %{}, _env} = Okta.Users.create_user(client, profile, false)
  end

  test "create_user/4 with activated profile and credentials requests correctly", %{
    client: client,
    base_url: base_url,
    profile: profile,
    credentials: credentials
  } do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        {:ok, expected_body} = Jason.encode(%{profile: profile, credentials: credentials})
        assert expected_body == request.body
        assert :post == request.method
        assert [activate: false] = request.query
        assert "#{base_url}/api/v1/users" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, %{}, _env} =
             Okta.Users.create_user(client, profile, false, credentials: credentials)
  end

  test "create_user/4 with activated profile, credentials, groupIds requests correctly", %{
    client: client,
    base_url: base_url,
    profile: profile,
    credentials: credentials,
    group_ids: group_ids
  } do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        {:ok, expected_body} =
          Jason.encode(%{profile: profile, credentials: credentials, groupIds: group_ids})

        assert expected_body == request.body
        assert :post == request.method
        assert [activate: false] = request.query
        assert "#{base_url}/api/v1/users" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, %{}, _env} =
             Okta.Users.create_user(client, profile, false,
               credentials: credentials,
               group_ids: group_ids
             )
  end

  test "create_user/4 with activated profile, credentials, groupIds and provider requests correctly",
       %{
         client: client,
         base_url: base_url,
         profile: profile,
         provider_credentials: credentials,
         group_ids: group_ids
       } do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        {:ok, expected_body} =
          Jason.encode(%{
            profile: profile,
            credentials: credentials,
            groupIds: group_ids
          })

        assert expected_body == request.body
        assert :post == request.method
        assert [provider: true, activate: false] = request.query
        assert "#{base_url}/api/v1/users" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

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
         base_url: base_url,
         profile: profile,
         provider_credentials: credentials,
         group_ids: group_ids
       } do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        {:ok, expected_body} =
          Jason.encode(%{
            profile: profile,
            credentials: credentials,
            groupIds: group_ids
          })

        assert expected_body == request.body
        assert :post == request.method
        assert [nextLogin: "changePassword", provider: true, activate: false] = request.query
        assert "#{base_url}/api/v1/users" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

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
    base_url: base_url,
    profile: profile
  } do
    password = "create_user_with_password"

    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        {:ok, expected_body} =
          Jason.encode(%{profile: profile, credentials: %{password: %{value: password}}})

        assert expected_body == request.body
        assert :post == request.method
        assert [activate: true] = request.query
        assert "#{base_url}/api/v1/users" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, %{}, _env} = Okta.Users.create_user_with_password(client, profile, password)
  end

  test "create_user_with_password/4 with activate requests correctly", %{
    client: client,
    base_url: base_url,
    profile: profile
  } do
    password = "create_user_with_password"

    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        {:ok, expected_body} =
          Jason.encode(%{profile: profile, credentials: %{password: %{value: password}}})

        assert expected_body == request.body
        assert :post == request.method
        assert [activate: false] = request.query
        assert "#{base_url}/api/v1/users" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, %{}, _env} =
             Okta.Users.create_user_with_password(client, profile, password, false)
  end

  test "create_user_with_provider/4 requests correctly", %{
    client: client,
    base_url: base_url,
    profile: profile
  } do
    provider_nametype = "SOCIAL"

    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        {:ok, expected_body} =
          Jason.encode(%{
            profile: profile,
            credentials: %{provider: %{name: provider_nametype, type: provider_nametype}}
          })

        assert expected_body == request.body
        assert :post == request.method
        assert [provider: true, activate: true] = request.query
        assert "#{base_url}/api/v1/users" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, %{}, _env} =
             Okta.Users.create_user_with_provider(
               client,
               profile,
               provider_nametype,
               provider_nametype
             )
  end

  test "update_user/4 requests correctly", %{
    client: client,
    base_url: base_url,
  } do
    user_id = "123"
    data = %{profile: %{login: "newlogin@acmec.com"}}

    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        {:ok, expected_body} = Jason.encode(data)

        assert expected_body == request.body
        assert :put == request.method
        assert [strict: true] = request.query
        assert "#{base_url}/api/v1/users/#{user_id}" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, %{}, _env} =
             Okta.Users.update_user(client, user_id, data, [strict: true])
  end

  test "update_profile/4 requests correctly", %{
    client: client,
    base_url: base_url,
  } do
    user_id = "123"
    data = %{profile: %{login: "newlogin@acmec.com"}}

    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        {:ok, expected_body} = Jason.encode(data)

        assert expected_body == request.body
        assert :put == request.method
        assert [strict: true] = request.query
        assert "#{base_url}/api/v1/users/#{user_id}" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, %{}, _env} =
             Okta.Users.update_user(client, user_id, data, [strict: true])
  end
end
