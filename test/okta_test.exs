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
end
