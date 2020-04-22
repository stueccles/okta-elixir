defmodule Okta.IdPs.Policy do
  @moduledoc """
  The `Okta.IdPs.Policy` represents an Okta Policy Object for both creation and retrieval

  https://developer.okta.com/docs/reference/api/idps/#policy-object
  """
  defstruct [
    :provisioning,
    :accountLink,
    :subject,
    :maxClockSkew
  ]

  @type t :: %__MODULE__{}

  @doc """
  Creates a partial Policy that will autoprovision Idp users to a group
  """
  @spec auto_provision_to_groups_policy(list(String.t())) :: t()
  def auto_provision_to_groups_policy(group_ids) do
    %__MODULE__{
      provisioning: %{
        "action" => "AUTO",
        "conditions" => %{
          "deprovisioned" => %{"action" => "NONE"},
          "suspended" => %{"action" => "NONE"}
        },
        "groups" => %{
          "action" => "ASSIGN",
          "assignments" => group_ids
        },
        "profileMaster" => false
      }
    }
  end

  @doc """
  Creates a partial Policy that will disable autoprovisioning in an Idp
  """
  @spec no_auto_provision_policy :: t()
  def no_auto_provision_policy() do
    %__MODULE__{
      provisioning: %{
        "action" => "DISABLED",
        "conditions" => %{
          "deprovisioned" => %{"action" => "NONE"},
          "suspended" => %{"action" => "NONE"}
        },
        "groups" => %{"action" => "NONE"},
        "profileMaster" => false
      }
    }
  end
end
