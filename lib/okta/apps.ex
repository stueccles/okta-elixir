defmodule Okta.Apps do
  @moduledoc """
  The `Okta.Apps` module provides access methods to the [Okta Apps API](https://developer.okta.com/docs/reference/api/apps/).

  All methods require a Tesla Client struct created with `Okta.client(base_url, api_key)`.

  ## Examples

      client = Okta.Client("https://dev-000000.okta.com", "thisismykeycreatedinokta")
      {:ok, result, _env} = Okta.Groups.list_applications(client)

  """

  @apps_url "/api/v1/apps"

  @doc """
  Adds a new application to your organization.

  The `app` parameter is a map containing the app specific `name`, `signOnMode` and `settings`.
  The API documentation has examples of different types of apps and the required parameters.

  ## Examples
  ```
      client = Okta.Client("https://dev-000000.okta.com", "thisismykeycreatedinokta")
      {:ok, result, _env} = Okta.Apps.add_application(client, %{
        name: "bookmark", label: "Sample bookmark App", signOnMode: "BOOKMARK", settings: %{ app: %{ requestIntegration: false, url: "https://example.com/bookmark.htm"}}
      })
  ```
  https://developer.okta.com/docs/reference/api/apps/#add-application
  """
  @spec add_application(Okta.client(), map(), boolean) :: Okta.result()
  def add_application(client, app, activate \\ true) do
    Tesla.post(client, @apps_url, app, query: [activate: activate]) |> Okta.result()
  end

  @doc """
  Adds a new OAuth2 application to your organization.

  The `label` parameter is a string readablle label for the application, while `client_credentials` and `settings` are the configured of the application.
  None of the values of `client_credentials` are required but `client_settings` have different requirements depending on what is set for `grant_types` (which is required) in `settings`

  ## Examples
  ```
  Okta.Apps.add_oauth2_application(client,
                                   "Label",
                                   %{},
                                   %{grant_types: ["implicit"],
                                     redirect_uris: ["http://localhost:3000/implicit/callback"],
                                     response_types: ["id_token", "token"],
                                     application_type: "browser"})
  ```
  The API documentation has examples of different types of apps and the required parameters.

  https://developer.okta.com/docs/reference/api/apps/#add-oauth-2-0-client-application
  """
  @spec add_oauth2_application(Okta.client(), String.t(), map(), map(), boolean()) ::
          Okta.result()
  def add_oauth2_application(client, label, client_credentials, client_settings, activate \\ true) do
    add_application(
      client,
      %{
        name: "oidc_client",
        signOnMode: "OPENID_CONNECT",
        label: label,
        credentials: %{oauthClient: client_credentials},
        settings: %{oauthClient: client_settings}
      },
      activate
    )
  end

  @doc """
  Fetches an application from your Okta organization by `application_id`.

  https://developer.okta.com/docs/reference/api/apps/#get-application
  """
  @spec get_application(Okta.client(), String.t()) :: Okta.result()
  def get_application(client, application_id) do
    Tesla.get(client, @apps_url <> "/#{application_id}") |> Okta.result()
  end

  @doc """
  Enumerates apps added to your organization with pagination. A subset of apps can be returned that match a supported filter expression or query.

  See API documentation for valid optional parameters

  https://developer.okta.com/docs/reference/api/apps/#list-applications
  """
  @spec list_applications(Okta.client(), keyword()) :: Okta.result()
  def list_applications(client, opts \\ []) do
    Tesla.get(client, @apps_url, query: opts) |> Okta.result()
  end

  @doc """
  Enumerates apps added to your organization with pagination given a specific filter expression

  https://developer.okta.com/docs/reference/api/apps/#list-applications
  """
  @spec filter_applications(Okta.client(), String.t(), keyword()) :: Okta.result()
  def filter_applications(client, filter, opts \\ []) do
    list_applications(client, Keyword.merge(opts, filter: filter))
  end

  @doc """
  Enumerates all applications assigned to a user and optionally embeds their Application User in a single response.

  https://developer.okta.com/docs/reference/api/apps/#list-applications-assigned-to-user
  """
  @spec list_applications_for_user(Okta.client(), String.t(), boolean, keyword()) :: Okta.result()
  def list_applications_for_user(client, user_id, expand \\ false, opts \\ []) do
    filter =
      case expand do
        true -> "user.id+eq+\"#{user_id}\"&expand=user/#{user_id}"
        false -> "user.id+eq+\"#{user_id}\""
      end

    filter_applications(client, filter, opts)
  end

  @doc """
  Enumerates all applications assigned to a group

  https://developer.okta.com/docs/reference/api/apps/#list-applications-assigned-to-group
  """
  @spec list_applications_for_group(Okta.client(), String.t(), keyword()) :: Okta.result()
  def list_applications_for_group(client, group_id, opts \\ []) do
    filter = "group.id+eq+\"#{group_id}\""
    filter_applications(client, filter, opts)
  end

  @doc """
  Enumerates all applications using a key.

  https://developer.okta.com/docs/reference/api/apps/#list-applications-using-a-key
  """
  @spec list_applications_for_key(Okta.client(), String.t(), keyword()) :: Okta.result()
  def list_applications_for_key(client, key, opts \\ []) do
    filter = "credentials.signing.kid+eq+\"#{key}\""
    filter_applications(client, filter, opts)
  end

  @doc """
  Updates an application in your organization.

  https://developer.okta.com/docs/reference/api/apps/#update-application
  """
  @spec update_application(Okta.client(), String.t(), map()) :: Okta.result()
  def update_application(client, app_id, app) do
    Tesla.put(client, @apps_url <> "/#{app_id}", app) |> Okta.result()
  end

  @doc """
  Removes an inactive application.

  https://developer.okta.com/docs/reference/api/apps/#delete-application
  """
  @spec delete_application(Okta.client(), String.t()) :: Okta.result()
  def delete_application(client, app_id) do
    Tesla.delete(client, @apps_url <> "/#{app_id}") |> Okta.result()
  end

  @doc """
  Activates an inactive application.

  https://developer.okta.com/docs/reference/api/apps/#activate-application
  """
  @spec activate_application(Okta.client(), String.t()) :: Okta.result()
  def activate_application(client, app_id) do
    Tesla.post(client, @apps_url <> "/#{app_id}" <> "/lifecycle/activate", %{}) |> Okta.result()
  end

  @doc """
  Deactivates an active application.

  https://developer.okta.com/docs/reference/api/apps/#deactivate-application
  """
  @spec deactivate_application(Okta.client(), String.t()) :: Okta.result()
  def deactivate_application(client, app_id) do
    Tesla.post(client, @apps_url <> "/#{app_id}" <> "/lifecycle/deactivate", %{}) |> Okta.result()
  end

  @doc """
  Assign a user to an application which can be done with and without application specific credentials and profile for SSO and provisioning

  https://developer.okta.com/docs/reference/api/apps/#application-user-operations
  """
  @spec assign_user_to_application(Okta.client(), String.t(), String.t(), map(), map()) ::
          Okta.result()
  def assign_user_to_application(client, app_id, user_id, credentials \\ %{}, profile \\ %{}) do
    Tesla.post(client, @apps_url <> "/#{app_id}" <> "/users", %{
      id: user_id,
      scope: "USER",
      credentials: credentials,
      profile: profile
    })
    |> Okta.result()
  end

  @doc """
  Fetches a specific user assignment for an application by id.

  https://developer.okta.com/docs/reference/api/apps/#get-assigned-user-for-application
  """
  @spec get_user_for_application(Okta.client(), String.t(), String.t()) :: Okta.result()
  def get_user_for_application(client, application_id, user_id) do
    Tesla.get(client, @apps_url <> "/#{application_id}" <> "/users/#{user_id}") |> Okta.result()
  end

  @doc """
  Enumerates all assigned application users for an application.

  https://developer.okta.com/docs/reference/api/apps/#list-users-assigned-to-application
  """
  @spec list_users_for_application(Okta.client(), String.t(), keyword()) :: Okta.result()
  def list_users_for_application(client, application_id, opts \\ []) do
    Tesla.get(client, @apps_url <> "/#{application_id}" <> "/users", query: opts) |> Okta.result()
  end

  @doc """
  Update a user for an application, either a profile, credentials or both can be provided.

  https://developer.okta.com/docs/reference/api/apps/#update-application-credentials-for-assigned-user
  """
  @spec update_user_for_application(
          Okta.client(),
          String.t(),
          String.t(),
          map() | nil,
          map() | nil
        ) :: Okta.result()
  def update_user_for_application(client, app_id, user_id, nil, profile),
    do: update_user_for_applicationp(client, app_id, user_id, %{profile: profile})

  def update_user_for_application(client, app_id, user_id, credentials, nil),
    do: update_user_for_applicationp(client, app_id, user_id, %{credentials: credentials})

  def update_user_for_application(client, app_id, user_id, credentials, profile),
    do:
      update_user_for_applicationp(client, app_id, user_id, %{
        credentials: credentials,
        profile: profile
      })

  defp update_user_for_applicationp(client, app_id, user_id, body) do
    Tesla.post(client, @apps_url <> "/#{app_id}" <> "/users/#{user_id}", body) |> Okta.result()
  end

  @doc """
  Removes an assignment for a user from an application.

  https://developer.okta.com/docs/reference/api/apps/#remove-user-from-application
  """
  @spec remove_user_from_application(Okta.client(), String.t(), String.t()) :: Okta.result()
  def remove_user_from_application(client, app_id, user_id) do
    Tesla.delete(client, @apps_url <> "/#{app_id}" <> "/users/#{user_id}") |> Okta.result()
  end

  @doc """
  Assigns a group to an application

  https://developer.okta.com/docs/reference/api/apps/#application-group-operations
  """
  @spec assign_group_to_application(Okta.client(), String.t(), String.t(), map()) :: Okta.result()
  def assign_group_to_application(client, app_id, group_id, app_group \\ %{}) do
    Tesla.put(client, @apps_url <> "/#{app_id}" <> "/groups/#{group_id}", app_group)
    |> Okta.result()
  end

  @doc """
  Fetches an application group assignment

  https://developer.okta.com/docs/reference/api/apps/#get-assigned-group-for-application
  """
  @spec get_group_for_application(Okta.client(), String.t(), String.t()) :: Okta.result()
  def get_group_for_application(client, application_id, group_id) do
    Tesla.get(client, @apps_url <> "/#{application_id}" <> "/groups/#{group_id}") |> Okta.result()
  end

  @doc """
  Enumerates group assignments for an application

  https://developer.okta.com/docs/reference/api/apps/#list-groups-assigned-to-application
  """
  @spec list_groups_for_application(Okta.client(), String.t(), keyword()) :: Okta.result()
  def list_groups_for_application(client, application_id, opts \\ []) do
    Tesla.get(client, @apps_url <> "/#{application_id}" <> "/groups", query: opts)
    |> Okta.result()
  end

  @doc """
  Removes a group assignment from an application.

  https://developer.okta.com/docs/reference/api/apps/#remove-group-from-application
  """
  @spec remove_group_from_application(Okta.client(), String.t(), String.t()) :: Okta.result()
  def remove_group_from_application(client, app_id, group_id) do
    Tesla.delete(client, @apps_url <> "/#{app_id}" <> "/groups/#{group_id}") |> Okta.result()
  end
end
