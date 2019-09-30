if Code.ensure_loaded?(Plug) do
  defmodule Okta.Plug.EventHook do
    @moduledoc """
    This Plug handles Okta Event Hooks.

    It validates the incoming requests:
      * https://developer.okta.com/docs/concepts/event-hooks/

    And forward the command to the `Okta.Event.HookHandler`.

    Also implements Event Hooks verifications
      * https://developer.okta.com/docs/concepts/event-hooks/#verifying-an-event-hook

    ### Usage

    Using `Plug.Router`

        forward "/okta/event-hooks", to: Okta.Plug.EventHook, [
          event_handler: MyModule,
          secret_key: "my secret key"
        ]

    Using in `Phoenix.Router`

        forward "/slack", Okta.Plug.EventHook, [
          event_handler: MyModule,
          secret_key: "my secret key"
        ]

    ### Configuration

    * `event_handler`: A module that implements `Okta.EventHookHandler` behaviour.
    * `secret_key`: The secret key to validate the incoming requests. You could
    use `mfa` configuration as well.
    """

    @behaviour Plug

    alias Plug.Conn

    @allowed_methods ["GET", "POST"]

    def init(opts), do: opts

    def call(conn, opts) do
      conn
      |> valid_request_method?()
      |> authorize?(conn, opts)
      |> handle_request(conn, opts)
    end

    defp valid_request_method?(%{method: method}) do
      method in @allowed_methods
    end

    defp authorize?(false, _, _), do: false

    defp authorize?(_, conn, opts) do
      secret_key = secret_key(opts)

      conn
      |> request_key()
      |> verify(secret_key)
    end

    defp verify(token, token), do: true
    defp verify(_, _), do: false

    defp request_key(conn) do
      conn
      |> Conn.get_req_header("authorization")
      |> Enum.at(0)
    end

    defp handle_request(false, conn, _) do
      Conn.send_resp(conn, :not_found, "")
    end

    defp handle_request(_, %{method: "GET"} = conn, _), do: verify_event_hook(conn)
    defp handle_request(_, conn, opts), do: handle_event(conn, opts)

    defp verify_event_hook(conn) do
      body = Jason.encode!(%{verification: verification_challenge(conn)})

      conn
      |> Conn.put_resp_content_type("application/json")
      |> Conn.send_resp(:ok, body)
    end

    defp verification_challenge(conn) do
      conn
      |> Conn.get_req_header("x-okta-verification-challenge")
      |> Enum.at(0)
    end

    defp handle_event(conn, opts) do
      conn
      |> Map.get(:body_params)
      |> event_handler(opts).handle_event()

      Conn.send_resp(conn, :no_content, "")
    end

    defp event_handler(opts) do
      Keyword.fetch!(opts, :event_handler)
    rescue
      _ ->
        raise ArgumentError, "You forgot to configure the :event_handler for the plug."
    end

    defp secret_key(opts) do
      case secret_key_from_opts(opts) do
        {m, f, a} -> apply(m, f, a)
        secret_key -> secret_key
      end
    end

    defp secret_key_from_opts(opts) do
      Keyword.fetch!(opts, :secret_key)
    rescue
      _ ->
        raise ArgumentError, "You forgot to configure the :secret_key for the plug."
    end
  end
end
