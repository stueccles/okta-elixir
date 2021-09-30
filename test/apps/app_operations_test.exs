defmodule Okta.AppOperationsTest do
  use ExUnit.Case
  alias Okta.TestSupport.Helpers
  doctest Okta.Apps

  setup do
    token = "ssws_token"
    client = Okta.client(Helpers.base_url(), token)

    bookmark_app = %{
      name: "bookmark",
      label: "Sample bookmark App",
      signOnMode: "BOOKMARK",
      settings: %{app: %{requestIntegration: false, url: "https://example.com/bookmark.htm"}}
    }

    client_credentials = %{client_id: "sfgearg3ebfsf"}

    client_settings = %{
      grant_types: ["implicit"],
      redirect_uris: ["http://localhost:3000/implicit/callback"],
      response_types: ["id_token", "token"],
      application_type: "browser"
    }

    label = "Testing OAuth2 Okta Apps"

    oauth2_app = %{
      name: "oidc_client",
      signOnMode: "OPENID_CONNECT",
      label: label,
      credentials: %{oauthClient: client_credentials},
      settings: %{oauthClient: client_settings}
    }

    {:ok,
     %{
       client: client,
       bookmark_app: bookmark_app,
       oauth2_app: oauth2_app,
       client_credentials: client_credentials,
       client_settings: client_settings,
       label: label
     }}
  end

  test "add_application/2 with full app requests correctly", %{
    client: client,
    bookmark_app: bookmark_app
  } do
    Helpers.mock_request(
      path: "/api/v1/apps",
      method: :post,
      query: [activate: true],
      body: Jason.encode!(bookmark_app),
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Apps.add_application(client, bookmark_app)
  end

  test "add_application/3 with full app requests correctly", %{
    client: client,
    bookmark_app: bookmark_app
  } do
    Helpers.mock_request(
      path: "/api/v1/apps",
      method: :post,
      query: [activate: false],
      body: Jason.encode!(bookmark_app),
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Apps.add_application(client, bookmark_app, false)
  end

  test "add_oauth2_application/5 with full app requests correctly", %{
    client: client,
    oauth2_app: oauth2_app,
    client_credentials: client_credentials,
    client_settings: client_settings,
    label: label
  } do
    Helpers.mock_request(
      path: "/api/v1/apps",
      method: :post,
      query: [activate: true],
      body: Jason.encode!(oauth2_app),
      status: 200
    )

    assert {:ok, %{}, _env} =
             Okta.Apps.add_oauth2_application(client, label, client_credentials, client_settings)
  end

  test "get_application/2 requests correctly", %{
    client: client
  } do
    application_id = "sdfwerwef"

    Helpers.mock_request(
      path: "/api/v1/apps/#{application_id}",
      method: :get,
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Apps.get_application(client, application_id)
  end

  test "list_applications/1 requests correctly", %{
    client: client
  } do
    Helpers.mock_request(
      path: "/api/v1/apps",
      method: :get,
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Apps.list_applications(client)
  end

  test "list_applications/2 requests correctly", %{
    client: client
  } do
    Helpers.mock_request(
      path: "/api/v1/apps",
      method: :get,
      query: [q: "query"],
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Apps.list_applications(client, q: "query")
  end

  test "filter_applications/2 requests correctly", %{
    client: client
  } do
    filter = "user.id+eq+\"45353453\""

    Helpers.mock_request(
      path: "/api/v1/apps",
      method: :get,
      query: [filter: filter],
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Apps.filter_applications(client, filter)
  end

  test "list_applications_for_user/2 requests correctly", %{
    client: client
  } do
    user_id = "435345345"

    filter = "user.id+eq+\"#{user_id}\""

    Helpers.mock_request(
      path: "/api/v1/apps",
      method: :get,
      query: [filter: filter],
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Apps.list_applications_for_user(client, user_id)
  end

  test "list_applications_for_group/2 requests correctly", %{
    client: client
  } do
    group_id = "435345345"

    filter = "group.id+eq+\"#{group_id}\""

    Helpers.mock_request(
      path: "/api/v1/apps",
      method: :get,
      query: [filter: filter],
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Apps.list_applications_for_group(client, group_id)
  end

  test "list_applications_for_key/2 requests correctly", %{
    client: client
  } do
    key = "435345345"

    filter = "credentials.signing.kid+eq+\"#{key}\""

    Helpers.mock_request(
      path: "/api/v1/apps",
      method: :get,
      query: [filter: filter],
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Apps.list_applications_for_key(client, key)
  end

  test "update_application/3 with full app requests correctly", %{
    client: client,
    bookmark_app: bookmark_app
  } do
    app_id = "23rwerwf34"

    Helpers.mock_request(
      path: "/api/v1/apps/#{app_id}",
      method: :put,
      body: Jason.encode!(bookmark_app),
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Apps.update_application(client, app_id, bookmark_app)
  end

  test "delete_application/2 requests correctly", %{
    client: client
  } do
    app_id = "23rwerwf34"

    Helpers.mock_request(
      path: "/api/v1/apps/#{app_id}",
      method: :delete,
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Apps.delete_application(client, app_id)
  end

  test "activate_application/2 requests correctly", %{
    client: client
  } do
    app_id = "23rwerwf34"

    Helpers.mock_request(
      path: "/api/v1/apps/#{app_id}/lifecycle/activate",
      method: :post,
      body: Jason.encode!(%{}),
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Apps.activate_application(client, app_id)
  end

  test "deactivate_application/2 requests correctly", %{
    client: client
  } do
    app_id = "23rwerwf34"

    Helpers.mock_request(
      path: "/api/v1/apps/#{app_id}/lifecycle/deactivate",
      method: :post,
      body: Jason.encode!(%{}),
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Apps.deactivate_application(client, app_id)
  end
end
