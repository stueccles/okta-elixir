defmodule Okta.Plug.EventHookTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.Conn
  alias Okta.Plug.EventHook

  @opts EventHook.init(
          event_handler: EventHookHandlerMock,
          secret_key: "authorization token"
        )

  test "returns 404 with unauthorized requests" do
    conn =
      :post
      |> conn("/okta/event-hooks")
      |> EventHook.call(@opts)

    assert conn.status == 404
  end

  test "veryfying event hooks" do
    conn =
      :get
      |> conn("/okta/event-hooks")
      |> Conn.put_req_header("x-okta-verification-challenge", "my verification challenge")
      |> Conn.put_req_header("authorization", "authorization token")
      |> EventHook.call(@opts)

    assert conn.status == 200
    assert conn.resp_body == Jason.encode!(%{verification: "my verification challenge"})
  end
end
