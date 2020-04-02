defmodule Okta.IdPs.IdentityProvider do
  @moduledoc """
  The `Okta.IdPs.IdentityProvider` represents an Okta IDP for both creation and retrieval
  """
  import Okta.Utils

  alias Okta.IdPs.{Policy, Protocol}

  defstruct [
    :_links,
    :created,
    :id,
    :issuerMode,
    :lastUpdated,
    :status,
    :type,
    :name,
    :protocol,
    :policy
  ]

  @doc """
  Returns a default Google IdP with the given name, client_id and client_secret.

  This IDP will be without auto provisioning. To get an auto provisioning Google Idp to a group you can do
  ```
  Okta.IdPs.IdentityProvider.google(name, client_id, client_secret)
  |> Okta.Utils.merge_struct(%Okta.IdPs.IdentityProvider{policy: Okta.IdPs.Policy.auto_provision_to_groups_policy([group_id])})

  https://developer.okta.com/docs/reference/api/users/#get-user
  """
  @spec google(String.t(), String.t(), String.t()) :: __MODULE__.t()
  def google(name, client_id, client_secret) do
    protocol = %Protocol{
      credentials: %{
        "client" => %{
          "client_id" => client_id,
          "client_secret" => client_secret
        }
      },
      endpoints: %{
        "authorization" => %{
          "binding" => "HTTP-REDIRECT",
          "url" => "https://accounts.google.com/o/oauth2/auth"
        },
        "token" => %{
          "binding" => "HTTP-POST",
          "url" => "https://www.googleapis.com/oauth2/v3/token"
        }
      },
      scopes: ["email", "openid", "profile"],
      type: "OIDC"
    }

    policy =
      %Policy{
        accountLink: %{action: "AUTO", filter: nil},
        maxClockSkew: 0,
        subject: %{
          "filter" => nil,
          "matchAttribute" => "",
          "matchType" => "USERNAME",
          "userNameTemplate" => %{"template" => "idpuser.email"}
        }
      }
      |> merge_struct(Policy.no_auto_provision_policy())

    %__MODULE__{name: name, type: "GOOGLE", policy: policy, protocol: protocol}
  end
end
