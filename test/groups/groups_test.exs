defmodule Okta.GroupsTest do
  use ExUnit.Case
  doctest Okta.Users

  setup do
    base_url = "https://dev-000000.okta.com"
    token = "ssws_token"

    profile = %{
      name: "Group Name",
      description: "Group Description"
    }

    group_id = "group1234123"
    user_id = "group1234123"

    client = Okta.client(base_url, token)

    {:ok,
     %{
       client: client,
       base_url: base_url,
       token: token,
       profile: profile,
       group_id: group_id,
       user_id: user_id
     }}
  end

  test "create_group/2 with just profile requests correctly", %{
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
        assert "#{base_url}/api/v1/groups" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, %{}, _env} = Okta.Groups.create_group(client, profile)
  end

  test "update_group/3 with just profile requests correctly", %{
    client: client,
    base_url: base_url,
    group_id: group_id,
    profile: profile
  } do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        {:ok, expected_body} = Jason.encode(%{profile: profile})
        assert expected_body == request.body
        assert :put == request.method
        assert "#{base_url}/api/v1/groups/#{group_id}" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, %{}, _env} = Okta.Groups.update_group(client, group_id, profile)
  end

  test "delete_group/2 requests correctly", %{
    client: client,
    base_url: base_url,
    group_id: group_id
  } do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert :delete == request.method
        assert "#{base_url}/api/v1/groups/#{group_id}" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, %{}, _env} = Okta.Groups.delete_group(client, group_id)
  end

  test "get_group/2 requests correctly", %{
    client: client,
    base_url: base_url,
    group_id: group_id
  } do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert :get == request.method
        assert "#{base_url}/api/v1/groups/#{group_id}" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, %{}, _env} = Okta.Groups.get_group(client, group_id)
  end

  test "list_group_members/2 requests correctly", %{
    client: client,
    base_url: base_url,
    group_id: group_id
  } do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert :get == request.method
        assert "#{base_url}/api/v1/groups/#{group_id}/users" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, %{}, _env} = Okta.Groups.list_group_members(client, group_id)
  end

  test "list_group_apps/2 requests correctly", %{
    client: client,
    base_url: base_url,
    group_id: group_id
  } do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert :get == request.method
        assert "#{base_url}/api/v1/groups/#{group_id}/apps" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, %{}, _env} = Okta.Groups.list_group_apps(client, group_id)
  end

  test "remove_user_from_group/3 requests correctly", %{
    client: client,
    base_url: base_url,
    group_id: group_id,
    user_id: user_id
  } do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert :delete == request.method
        assert "#{base_url}/api/v1/groups/#{group_id}/users/#{user_id}" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, %{}, _env} = Okta.Groups.remove_user_from_group(client, group_id, user_id)
  end

  test "add_user_to_group/3 requests correctly", %{
    client: client,
    base_url: base_url,
    group_id: group_id,
    user_id: user_id
  } do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert :put == request.method
        assert "#{base_url}/api/v1/groups/#{group_id}/users/#{user_id}" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, %{}, _env} = Okta.Groups.add_user_to_group(client, group_id, user_id)
  end

  test "list_groups/1 requests correctly", %{
    client: client,
    base_url: base_url
  } do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert :get == request.method
        assert "#{base_url}/api/v1/groups" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, %{}, _env} = Okta.Groups.list_groups(client)
  end

  test "list_groups/2 requests correctly", %{
    client: client,
    base_url: base_url
  } do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert :get == request.method
        assert [limit: 10, after: 200] == request.query
        assert "#{base_url}/api/v1/groups" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, %{}, _env} = Okta.Groups.list_groups(client, limit: 10, after: 200)
  end

  test "search_groups/3 requests correctly", %{
    client: client,
    base_url: base_url
  } do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert :get == request.method
        assert [limit: 10, after: 200, q: "search"] == request.query
        assert "#{base_url}/api/v1/groups" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, %{}, _env} = Okta.Groups.search_groups(client, "search", limit: 10, after: 200)
  end

  test "filter_groups/3 requests correctly", %{
    client: client,
    base_url: base_url
  } do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert :get == request.method
        assert [limit: 10, after: 200, filter: "search"] == request.query
        assert "#{base_url}/api/v1/groups" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, %{}, _env} = Okta.Groups.filter_groups(client, "search", limit: 10, after: 200)
  end

  test "list_groups_of_type/3 requests correctly", %{
    client: client,
    base_url: base_url
  } do
    type = "OKTA_TYPE"

    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert :get == request.method
        assert [limit: 10, after: 200, filter: "type eq \"#{type}\""] == request.query
        assert "#{base_url}/api/v1/groups" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, %{}, _env} = Okta.Groups.list_groups_of_type(client, type, limit: 10, after: 200)
  end

  test "list_groups_profile_updated_after/3 requests correctly", %{
    client: client,
    base_url: base_url
  } do
    now = DateTime.utc_now()

    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert :get == request.method

        assert [
                 limit: 10,
                 after: 200,
                 filter: "lastUpdated gt \"#{DateTime.to_iso8601(now, :extended)}\""
               ] == request.query

        assert "#{base_url}/api/v1/groups" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, %{}, _env} =
             Okta.Groups.list_groups_profile_updated_after(client, now, limit: 10, after: 200)
  end

  test "list_groups_membership_updated_after/3 requests correctly", %{
    client: client,
    base_url: base_url
  } do
    now = DateTime.utc_now()

    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert :get == request.method

        assert [
                 limit: 10,
                 after: 200,
                 filter: "lastMembershipUpdated gt \"#{DateTime.to_iso8601(now, :extended)}\""
               ] == request.query

        assert "#{base_url}/api/v1/groups" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, %{}, _env} =
             Okta.Groups.list_groups_membership_updated_after(client, now, limit: 10, after: 200)
  end

  test "list_groups_updated_after/3 requests correctly", %{
    client: client,
    base_url: base_url
  } do
    now = DateTime.utc_now()

    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert :get == request.method

        assert [
                 limit: 10,
                 after: 200,
                 filter:
                   "lastUpdated gt \"#{DateTime.to_iso8601(now, :extended)}\" or lastMembershipUpdated gt \"#{
                     DateTime.to_iso8601(now, :extended)
                   }\""
               ] == request.query

        assert "#{base_url}/api/v1/groups" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, %{}, _env} =
             Okta.Groups.list_groups_updated_after(client, now, limit: 10, after: 200)
  end
end
