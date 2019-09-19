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

end
