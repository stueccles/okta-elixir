defmodule Okta.AppGroupTest do
  use ExUnit.Case
  alias Okta.TestSupport.Helpers
  doctest Okta.Apps

  setup do
    token = "ssws_token"
    client = Okta.client(Helpers.base_url(), token)
    app_id = "345svbd235fasf"
    group_id = "dsfe45gdfsaf"

    {:ok,
     %{
       client: client,
       group_id: group_id,
       app_id: app_id
     }}
  end

  test "assign_group_to_application/3  requests correctly", %{
    client: client,
    group_id: group_id,
    app_id: app_id
  } do
    Helpers.mock_request(
      path: "/api/v1/apps/#{app_id}/groups/#{group_id}",
      method: :put,
      body: Jason.encode!(%{}),
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Apps.assign_group_to_application(client, app_id, group_id)
  end

  test "assign_group_to_application/4  requests correctly", %{
    client: client,
    group_id: group_id,
    app_id: app_id
  } do
    Helpers.mock_request(
      path: "/api/v1/apps/#{app_id}/groups/#{group_id}",
      method: :put,
      body: Jason.encode!(%{priority: 5}),
      status: 200
    )

    assert {:ok, %{}, _env} =
             Okta.Apps.assign_group_to_application(client, app_id, group_id, %{priority: 5})
  end

  test "get_group_for_application/3 requests correctly", %{
    client: client,
    group_id: group_id,
    app_id: app_id
  } do
    Helpers.mock_request(
      path: "/api/v1/apps/#{app_id}/groups/#{group_id}",
      method: :get,
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Apps.get_group_for_application(client, app_id, group_id)
  end

  test "list_groups_for_application/2 requests correctly", %{
    client: client,
    app_id: app_id
  } do
    Helpers.mock_request(
      path: "/api/v1/apps/#{app_id}/groups",
      method: :get,
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Apps.list_groups_for_application(client, app_id)
  end

  test "list_groups_for_application/3 requests correctly", %{
    client: client,
    app_id: app_id
  } do
    Helpers.mock_request(
      path: "/api/v1/apps/#{app_id}/groups",
      method: :get,
      query: [q: "query"],
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Apps.list_groups_for_application(client, app_id, q: "query")
  end

  test "remove_group_from_application/3 requests correctly", %{
    client: client,
    group_id: group_id,
    app_id: app_id
  } do
    Helpers.mock_request(
      path: "/api/v1/apps/#{app_id}/groups/#{group_id}",
      method: :delete,
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Apps.remove_group_from_application(client, app_id, group_id)
  end
end
