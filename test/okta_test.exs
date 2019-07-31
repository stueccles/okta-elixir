defmodule OktaTest do
  use ExUnit.Case
  doctest Okta

  test "client has correct headerss" do
    url = "https://dev-000000.okta.com"
    token = "ssws_token"
    client = Okta.client(url, token)

    assert client.pre == [
             {Tesla.Middleware.BaseUrl, :call, [url]},
             {Tesla.Middleware.JSON, :call, [[]]},
             {Tesla.Middleware.Headers, :call, [[{"authorization", "SSWS #{token}"}]]}
           ]
  end

  test "results under 300 status are ok" do
    body = %{body: "1"}
    env = %Tesla.Env{status: 200, body: body}

    assert {:ok, %{body: _}, %Tesla.Env{}} = Okta.result({:ok, env})
  end

  test "results over 300 status are not ok" do
    body = %{body: "1"}
    env = %Tesla.Env{status: 400, body: body}

    assert {:error, %{body: _}, %Tesla.Env{}} = Okta.result({:ok, env})
  end

  test "results that fail are not ok" do
    assert {:error, %{}, _} = Okta.result({:error, ""})
  end
end
