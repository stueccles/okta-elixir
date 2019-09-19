defmodule Okta.EventHookHandler do
  @type event :: %{}

  @callback handle_event(event :: event()) :: none()
end
