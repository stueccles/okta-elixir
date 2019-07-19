defmodule Okta.UsersFindTest do
  use ExUnit.Case
  doctest Okta.Users

  setup do
    base_url = "https://dev-000000.okta.com"
    token = "ssws_token"
    user_id = "user123124"
    client = Okta.client(base_url, token)
    {:ok, %{client: client, base_url: base_url, token: token, user_id: user_id}}
  end

  test "get_current_user/1 requests correctly", %{client: client, base_url: base_url} do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert :get == request.method
        assert "#{base_url}/api/v1/users/me" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} = Okta.Users.get_current_user(client)
  end

  test "get_user/2 requests correctly", %{client: client, base_url: base_url, user_id: user_id} do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert :get == request.method
        assert "#{base_url}/api/v1/users/#{user_id}" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} = Okta.Users.get_user(client, user_id)
  end

  test "get_assigned_applinks/2 requests correctly", %{
    client: client,
    base_url: base_url,
    user_id: user_id
  } do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert :get == request.method
        assert "#{base_url}/api/v1/users/#{user_id}/appLinks" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} = Okta.Users.get_assigned_applinks(client, user_id)
  end

  test "get_groups_for_user/2 requests correctly", %{
    client: client,
    base_url: base_url,
    user_id: user_id
  } do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert :get == request.method
        assert "#{base_url}/api/v1/users/#{user_id}/groups" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} = Okta.Users.get_groups_for_user(client, user_id)
  end

  test "list_users/1 requests correctly", %{client: client, base_url: base_url} do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert :get == request.method
        assert "#{base_url}/api/v1/users" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} = Okta.Users.list_users(client)
  end

  test "list_users/2 requests correctly", %{client: client, base_url: base_url} do
    limit = 45

    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert [limit: limit] = request.query
        assert :get == request.method
        assert "#{base_url}/api/v1/users" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} = Okta.Users.list_users(client, limit: limit)
  end

  test "search_users/2 requests correctly", %{client: client, base_url: base_url} do
    search_term = "searching"

    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert [search: search_term] = request.query
        assert :get == request.method
        assert "#{base_url}/api/v1/users" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} = Okta.Users.search_users(client, search_term)
  end

  test "filter_users/2 requests correctly", %{client: client, base_url: base_url} do
    filter = "filter eq \"term\""

    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert [filter: filter] = request.query
        assert :get == request.method
        assert "#{base_url}/api/v1/users" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} = Okta.Users.filter_users(client, filter)
  end

  test "list_active_users/1 requests correctly", %{client: client, base_url: base_url} do
    filter = "status eq \"ACTIVE\""

    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert [filter: filter] = request.query
        assert :get == request.method
        assert "#{base_url}/api/v1/users" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} = Okta.Users.list_active_users(client)
  end

  test "list_staged_users/1 requests correctly", %{client: client, base_url: base_url} do
    filter = "status eq \"STAGED\""

    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert [filter: filter] = request.query
        assert :get == request.method
        assert "#{base_url}/api/v1/users" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} = Okta.Users.list_staged_users(client)
  end

  test "list_recovery_users/1 requests correctly", %{client: client, base_url: base_url} do
    filter = "status eq \"RECOVERY\""

    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert [filter: filter] = request.query
        assert :get == request.method
        assert "#{base_url}/api/v1/users" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} = Okta.Users.list_recovery_users(client)
  end

  test "list_deprovisioned_users/1 requests correctly", %{client: client, base_url: base_url} do
    filter = "status eq \"DEPROVISIONED\""

    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert [filter: filter] = request.query
        assert :get == request.method
        assert "#{base_url}/api/v1/users" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} = Okta.Users.list_deprovisioned_users(client)
  end

  test "list_password_expired_users/1 requests correctly", %{client: client, base_url: base_url} do
    filter = "status eq \"PASSWORD_EXPIRED\""

    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert [filter: filter] = request.query
        assert :get == request.method
        assert "#{base_url}/api/v1/users" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} = Okta.Users.list_password_expired_users(client)
  end

  test "list_provisioned_users/1 requests correctly", %{client: client, base_url: base_url} do
    filter = "status eq \"PROVISIONED\""

    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert [filter: filter] = request.query
        assert :get == request.method
        assert "#{base_url}/api/v1/users" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} = Okta.Users.list_provisioned_users(client)
  end

  test "list_locked_users/1 requests correctly", %{client: client, base_url: base_url} do
    filter = "status eq \"LOCKED_OUT\""

    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert [filter: filter] = request.query
        assert :get == request.method
        assert "#{base_url}/api/v1/users" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} = Okta.Users.list_locked_users(client)
  end

  test "list_users_updated_after/1 requests correctly", %{client: client, base_url: base_url} do
    now = DateTime.utc_now()

    filter = "status eq \"ACTIVE\" and lastUpdated gt \"#{DateTime.to_iso8601(now, :extended)}\""

    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert [filter: filter] = request.query
        assert :get == request.method
        assert "#{base_url}/api/v1/users" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} = Okta.Users.list_users_updated_after(client, now)
  end
end
