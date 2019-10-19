defmodule Okta.TrustedOriginsTest do
  use ExUnit.Case
  alias Okta.TestSupport.Helpers
  doctest Okta.TrustedOrigins

  setup do
    token = "ssws_token"
    client = Okta.client(Helpers.base_url(), token)
    {:ok, %{client: client}}
  end

  test "create_trusted_origin/4 with cors and redirect requests correctly", %{
    client: client
  } do
    name = "Test"
    url = "https://example.com/test"

    Helpers.mock_request(
      path: "/api/v1/trustedOrigins",
      method: :post,
      body:
        Jason.encode!(%{name: name, origin: url, scopes: [%{type: "REDIRECT"}, %{type: "CORS"}]}),
      status: 200
    )

    assert {:ok, %{}, _env} =
             Okta.TrustedOrigins.create_trusted_origin(client, name, url, [:cors, :redirect])
  end

  test "create_trusted_origin/4 with just cors correctly", %{
    client: client
  } do
    name = "Test"
    url = "https://example.com/test"

    Helpers.mock_request(
      path: "/api/v1/trustedOrigins",
      method: :post,
      body: Jason.encode!(%{name: name, origin: url, scopes: [%{type: "CORS"}]}),
      status: 200
    )

    assert {:ok, %{}, _env} =
             Okta.TrustedOrigins.create_trusted_origin(client, name, url, [:cors])
  end

  test "create_trusted_origin/4 with just redirect correctly", %{
    client: client
  } do
    name = "Test"
    url = "https://example.com/test"

    Helpers.mock_request(
      path: "/api/v1/trustedOrigins",
      method: :post,
      body: Jason.encode!(%{name: name, origin: url, scopes: [%{type: "REDIRECT"}]}),
      status: 200
    )

    assert {:ok, %{}, _env} =
             Okta.TrustedOrigins.create_trusted_origin(client, name, url, [:redirect])
  end

  test "get_trusted_origin/2 requests correctly", %{
    client: client
  } do
    trusted_origin_id = "tosue7JvguwJ7U6kz0g3"

    Helpers.mock_request(
      path: "/api/v1/trustedOrigins/#{trusted_origin_id}",
      method: :get,
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.TrustedOrigins.get_trusted_origin(client, trusted_origin_id)
  end

  test "list_trusted_origin/1 requests correctly", %{
    client: client
  } do
    Helpers.mock_request(
      path: "/api/v1/trustedOrigins",
      method: :get,
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.TrustedOrigins.list_trusted_origins(client)
  end

  test "list_trusted_origin/2 requests correctly", %{
    client: client
  } do
    Helpers.mock_request(
      path: "/api/v1/trustedOrigins",
      method: :get,
      query: [limit: 1000],
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.TrustedOrigins.list_trusted_origins(client, limit: 1000)
  end

  test "filter_trusted_origins/2 requests correctly", %{
    client: client
  } do
    Helpers.mock_request(
      path: "/api/v1/trustedOrigins",
      method: :get,
      query: [filter: "query"],
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.TrustedOrigins.filter_trusted_origins(client, "query")
  end

  test "update_trusted_origin/5 with cors and redirect requests correctly", %{
    client: client
  } do
    name = "Test"
    url = "https://example.com/test"
    trusted_origin_id = "tosue7JvguwJ7U6kz0g3"

    Helpers.mock_request(
      path: "/api/v1/trustedOrigins/#{trusted_origin_id}",
      method: :put,
      body:
        Jason.encode!(%{name: name, origin: url, scopes: [%{type: "REDIRECT"}, %{type: "CORS"}]}),
      status: 200
    )

    assert {:ok, %{}, _env} =
             Okta.TrustedOrigins.update_trusted_origin(client, trusted_origin_id, name, url, [
               :cors,
               :redirect
             ])
  end

  test "delete_trusted_origin/2 requests correctly", %{
    client: client
  } do
    trusted_origin_id = "tosue7JvguwJ7U6kz0g3"

    Helpers.mock_request(
      path: "/api/v1/trustedOrigins/#{trusted_origin_id}",
      method: :delete,
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.TrustedOrigins.delete_trusted_origin(client, trusted_origin_id)
  end

  test "activate_trusted_origin/2 requests correctly", %{
    client: client
  } do
    trusted_origin_id = "tosue7JvguwJ7U6kz0g3"

    Helpers.mock_request(
      path: "/api/v1/trustedOrigins/#{trusted_origin_id}/lifecycle/activate",
      method: :post,
      body: Jason.encode!(%{}),
      status: 200
    )

    assert {:ok, %{}, _env} =
             Okta.TrustedOrigins.activate_trusted_origin(client, trusted_origin_id)
  end

  test "deactivate_trusted_origin/2 requests correctly", %{
    client: client
  } do
    trusted_origin_id = "tosue7JvguwJ7U6kz0g3"

    Helpers.mock_request(
      path: "/api/v1/trustedOrigins/#{trusted_origin_id}/lifecycle/deactivate",
      method: :post,
      body: Jason.encode!(%{}),
      status: 200
    )

    assert {:ok, %{}, _env} =
             Okta.TrustedOrigins.deactivate_trusted_origin(client, trusted_origin_id)
  end
end
