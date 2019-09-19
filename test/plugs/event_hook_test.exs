defmodule Okta.Plug.EventHookTest do
  use ExUnit.Case, async: true

  alias Plug.Test
  alias Plug.Conn
  alias Okta.Plug.EventHook

  @opts EventHook.init(
          event_handler: EventHookHandlerMock,
          secret_key: "authorization token"
        )

  test "returns 404 with unauthorized requests" do
    conn =
      :post
      |> Plug.Test.conn("/okta/event-hooks")
      |> EventHook.call(@opts)

    assert conn.status == 404
  end

  test "veryfying event hooks" do
    conn =
      :get
      |> Plug.Test.conn("/okta/event-hooks")
      |> Conn.put_req_header("x-okta-verification-challenge", "my verification challenge")
      |> Conn.put_req_header("authorization", "authorization token")
      |> EventHook.call(@opts)

    assert conn.status == 200
    assert conn.resp_body == Jason.encode!(%{verification: "my verification challenge"})
  end

  test "receiving events" do
    Mox.expect(EventHookHandlerMock, :handle_event, fn params ->
      assert params == "some data"
    end)

    conn =
      :post
      |> Plug.Test.conn("/okta/event-hooks")
      |> Conn.put_req_header("authorization", "authorization token")
      |> Map.put(:body_params, "some data")
      |> EventHook.call(@opts)

    assert conn.status == 204
  end
end
