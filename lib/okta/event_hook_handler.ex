defmodule Okta.EventHookHandler do
  @moduledoc """
  Event Hook Handler handles incoming Event Hook from Okta.

  Read more about Event Hooks in the official documation:

    * https://developer.okta.com/docs/concepts/event-hooks/
  """

  @type event :: %{}

  @callback handle_event(event :: event()) :: none()
end
