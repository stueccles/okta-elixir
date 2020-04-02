defmodule Okta.IdPs.Protocol do
  @moduledoc """
  The `Okta.IdPs.Protocol` represents an SAML 2.0 Protocol Object for both creation and retrieval

  https://developer.okta.com/docs/reference/api/idps/#protocol-object
  """
  defstruct [
    :type,
    :endpoints,
    :relayState,
    :algorithms,
    :credentials,
    :scopes,
    :settings
  ]
end
