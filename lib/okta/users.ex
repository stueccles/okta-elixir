defmodule Okta.Users do
  @moduledoc """
  The `Okta.Users` module provides access methods to the [Okta Users API](https://developer.okta.com/docs/reference/api/users/).

  All methods require a Tesla Client struct created with `Okta.client(base_url, api_key)`.

  ## Examples

  ```
  client = Okta.Client("https://dev-000000.okta.com", "thisismykeycreatedinokta")

  {:ok, result, _env} = Okta.Users.list_users(client)
  ```
  """

  @type client() :: Tesla.Client.t()
  @type result() :: {:ok, map(), Tesla.Env.t()} | {:error, map(), any}

  @users_url "/api/v1/users"

  @doc """
  Fetch a user by id, login, or login shortname if the short name is unambiguous.

  [https://developer.okta.com/docs/reference/api/users/#get-user](https://developer.okta.com/docs/reference/api/users/#get-user)
  """
  @spec get_user(client(), String.t()) :: result()
  def get_user(client, user) do
    Tesla.get(client, @users_url <> "/#{user}") |> Okta.result()
  end

  @doc """
  Fetches the current user linked to API token or session cookie

  [https://developer.okta.com/docs/reference/api/users/#get-current-user](https://developer.okta.com/docs/reference/api/users/#get-current-user)
  """
  @spec get_current_user(client()) :: result()
  def get_current_user(client) do
    Tesla.get(client, @users_url <> "/me") |> Okta.result()
  end

  @doc """
  Fetches appLinks for all direct or indirect (via group membership) assigned applications

  [https://developer.okta.com/docs/reference/api/users/#get-assigned-app-links](https://developer.okta.com/docs/reference/api/users/#get-assigned-app-links)
  """
  @spec get_assigned_applinks(client(), String.t()) :: result()
  def get_assigned_applinks(client, user_id) do
    Tesla.get(client, @users_url <> "/#{user_id}" <> "/appLinks") |> Okta.result()
  end

  @doc """
  Fetches the groups of which the user is a member

  [https://developer.okta.com/docs/reference/api/users/#get-user-s-groups](https://developer.okta.com/docs/reference/api/users/#get-user-s-groups)
  """
  @spec get_groups_for_user(client(), String.t()) :: result()
  def get_groups_for_user(client, user_id) do
    Tesla.get(client, @users_url <> "/#{user_id}" <> "/groups") |> Okta.result()
  end

  @doc """
  Removes all active identity provider sessions. This forces the user to authenticate on the next operation.
  Optionally revokes OpenID Connect and OAuth refresh and access tokens issued to the user.

  [https://developer.okta.com/docs/reference/api/users/#clear-user-sessions](https://developer.okta.com/docs/reference/api/users/#clear-user-sessions)

  """
  @spec clear_user_sessions(client(), String.t(), boolean()) :: result()
  def clear_user_sessions(client, user_id, oauth_tokens \\ false) do
    Tesla.delete(client, @users_url <> "/#{user_id}", query: [oauthTokens: oauth_tokens])
    |> Okta.result()
  end

  @doc """
  Lists users in your organization with pagination in most cases

  A subset of users can be returned that match a supported filter expression or search criteria.

  see
  [https://developer.okta.com/docs/reference/api/users/#list-users](https://developer.okta.com/docs/reference/api/users/#list-users)

  for optional parameters that can be passed in

  ##Example

  ```
    {:ok, result} = Okta.Users.list_users(client, q: "Noah", limit: 10, after: 200)
  ```
  """
  @spec list_users(client(), keyword()) :: result()
  def list_users(client, opts \\ []) do
    Tesla.get(client, @users_url, query: opts) |> Okta.result()
  end

  @doc """
  Shortcut method to use list_users with a `q` parameter.

  Finds users who match the specified query with a simple lookup of users by name, for example when creating a people picker. The value of query is matched against firstName, lastName, or email.

  [https://developer.okta.com/docs/reference/api/users/#find-users](https://developer.okta.com/docs/reference/api/users/#find-users)
  """
  @spec find_users(client(), String.t(), keyword()) :: result()
  def find_users(client, query, opts \\ []) do
    list_users(client, Keyword.merge(opts, q: query))
  end

  @doc """
  Shortcut method to use list_users with a `search` parameter. Searches for users based on the properties specified in the search_term

  see
  [https://developer.okta.com/docs/reference/api/users/#list-users-with-search](https://developer.okta.com/docs/reference/api/users/#list-users-with-search)
  for details
  """
  @spec search_users(client(), String.t(), keyword()) :: result()
  def search_users(client, search_term, opts \\ []) do
    list_users(client, Keyword.merge(opts, search: search_term))
  end

  @doc """
  Shortcut method to use list_users with a `filter` parameter. Lists all users that match the filter criteria

  see
  [https://developer.okta.com/docs/reference/api/users/#list-users-with-a-filter](https://developer.okta.com/docs/reference/api/users/#list-users-with-a-filter)
  for details

  and [https://developer.okta.com/docs/reference/api-overview/#filtering](https://developer.okta.com/docs/reference/api-overview/#filtering) on how Okta supports filters
  """
  @spec filter_users(client(), String.t(), keyword()) :: result()
  def filter_users(client, filter, opts \\ []) do
    list_users(client, Keyword.merge(opts, filter: filter))
  end

  @doc """
  Lists all active users. ie. Users that have a status of ACTIVE
  """
  @spec list_active_users(client(), keyword()) :: result()
  def list_active_users(client, opts \\ []) do
    filter_users(client, "status eq \"ACTIVE\"", opts)
  end

  @doc """
  Lists all staged users. ie. Users that have a status of STAGED
  """
  @spec list_staged_users(client(), keyword()) :: result()
  def list_staged_users(client, opts \\ []) do
    filter_users(client, "status eq \"STAGED\"", opts)
  end

  @doc """
  Lists all password recovery users. ie. Users that have a status of RECOVERY
  """
  @spec list_recovery_users(client()) :: result()
  @spec list_recovery_users(client(), keyword()) :: result()
  def list_recovery_users(client, opts \\ []) do
    filter_users(client, "status eq \"RECOVERY\"", opts)
  end

  @doc """
  Lists all deprovisioned users. ie. Users that have a status of DEPROVISIONED
  """
  @spec list_deprovisioned_users(client(), keyword()) :: result()
  def list_deprovisioned_users(client, opts \\ []) do
    filter_users(client, "status eq \"DEPROVISIONED\"", opts)
  end

  @doc """
  Lists all password expired users. ie. Users that have a status of PASSWORD_EXPIRED
  """
  @spec list_password_expired_users(client()) :: result()
  @spec list_password_expired_users(client(), keyword()) :: result()
  def list_password_expired_users(client, opts \\ []) do
    filter_users(client, "status eq \"PASSWORD_EXPIRED\"", opts)
  end

  @doc """
  Lists all provisioned users. ie. Users that have a status of PROVISIONED
  """
  @spec list_provisioned_users(client(), keyword()) :: result()
  def list_provisioned_users(client, opts \\ []) do
    filter_users(client, "status eq \"PROVISIONED\"", opts)
  end

  @doc """
  Lists all locked out users. ie. Users that have a status of LOCKED_OUT
  """
  @spec list_locked_users(client(), keyword()) :: result()
  def list_locked_users(client, opts \\ []) do
    filter_users(client, "status eq \"LOCKED_OUT\"", opts)
  end

  @doc """
  Lists all users who are active and were updated after a certain date and time.
  """
  @spec list_users_updated_after(client(), Calendar.datetime(), keyword()) :: result()
  def list_users_updated_after(client, updated_at, opts \\ []) do
    filter_users(
      client,
      "status eq \"ACTIVE\" and lastUpdated gt \"#{DateTime.to_iso8601(updated_at, :extended)}\"",
      opts
    )
  end

  @doc """
  Creates a new user in your Okta organization with or without credentials

  [https://developer.okta.com/docs/reference/api/users/#create-user](https://developer.okta.com/docs/reference/api/users/#create-user)
  """
  @spec create_user(client(), map(), boolean(), keyword()) :: result()
  def create_user(client, profile, activate \\ true, opts \\ []) do
    query_params = [activate: activate]

    query_params =
      if(Keyword.has_key?(opts, :provider),
        do: Keyword.put(query_params, :provider, opts[:provider]),
        else: query_params
      )

    query_params =
      if(Keyword.has_key?(opts, :next_login),
        do: Keyword.put(query_params, :nextLogin, opts[:next_login]),
        else: query_params
      )

    data = %{profile: profile}

    data =
      if(Keyword.has_key?(opts, :credentials),
        do: Map.put_new(data, :credentials, opts[:credentials]),
        else: data
      )

    data =
      if(Keyword.has_key?(opts, :group_ids),
        do: Map.put_new(data, :groupIds, opts[:group_ids]),
        else: data
      )

    Tesla.post(client, @users_url, data, query: query_params) |> Okta.result()
  end

  @doc """
  Creates a user without a recovery question & answer

  [https://developer.okta.com/docs/reference/api/users/#create-user-with-password](https://developer.okta.com/docs/reference/api/users/#create-user-with-password)
  """
  @spec create_user_with_password(client(), map(), String.t(), boolean(), keyword()) :: result()
  def create_user_with_password(client, profile, password, activate \\ true, opts \\ []) do
    create_user(
      client,
      profile,
      activate,
      Keyword.merge(opts, credentials: password_data(password))
    )
  end

  @doc """
  Creates a new passwordless user with a SOCIAL or FEDERATION authentication provider that must be authenticated via a trusted Identity Provider

  [https://developer.okta.com/docs/reference/api/users/#create-user-with-authentication-provider](https://developer.okta.com/docs/reference/api/users/#create-user-with-authentication-provider)
  """
  @spec create_user_with_provider(client(), map(), String.t(), String.t(), boolean(), keyword()) ::
          result()
  def create_user_with_provider(
        client,
        profile,
        provider_type,
        provider_name,
        activate \\ true,
        opts \\ []
      ) do
    create_user(
      client,
      profile,
      activate,
      Keyword.merge(opts,
        credentials: %{provider: %{type: provider_type, name: provider_name}},
        provider: true
      )
    )
  end

  @doc """
  Sets passwords without validating existing user credentials

  This is an administrative operation. For an operation that requires validation see `change_password/4`

  [https://developer.okta.com/docs/reference/api/users/#set-password](https://developer.okta.com/docs/reference/api/users/#set-password)

  """
  @spec set_password(client(), String.t(), String.t()) :: result()
  def set_password(client, user_id, password) do
    Tesla.post(client, @users_url <> "/#{user_id}", %{credentials: password_data(password)})
    |> Okta.result()
  end

  @doc """
  Changes a user's password by validating the user's current password

  This operation can only be performed on users in STAGED, ACTIVE, PASSWORD_EXPIRED, or RECOVERY status that have a valid password credential

  [https://developer.okta.com/docs/reference/api/users/#change-password](https://developer.okta.com/docs/reference/api/users/#change-password)
  """
  @spec change_password(client(), String.t(), String.t(), String.t(), boolean()) :: result()
  def change_password(client, user_id, old_password, new_password, strict \\ false) do
    Tesla.post(
      client,
      @users_url <> "/#{user_id}",
      %{
        credentials: %{oldPassword: %{value: old_password}, newPassword: %{value: new_password}}
      },
      query: [strict: strict]
    )
    |> Okta.result()
  end

  @doc """
  Sets recovery question and answer without validating existing user credentials

  This is an administrative operation. For an operation that requires validation see `change_recovery_credential/5`

  [https://developer.okta.com/docs/reference/api/users/#set-recovery-question-answer](https://developer.okta.com/docs/reference/api/users/#set-recovery-question-answer)
  """
  @spec set_recovery_credential(client(), String.t(), String.t(), String.t()) :: result()
  def set_recovery_credential(client, user_id, question, answer) do
    Tesla.put(client, @users_url <> "/#{user_id}", %{
      credentials: recovery_data(question, answer)
    })
    |> Okta.result()
  end

  @doc """
  Changes a user's recovery question & answer credential by validating the user's current password

  This operation can only be performed on users in STAGED, ACTIVE or RECOVERY status that have a valid password credential

  [https://developer.okta.com/docs/reference/api/users/#change-recovery-question](https://developer.okta.com/docs/reference/api/users/#change-recovery-question)
  """
  @spec change_recovery_credential(client(), String.t(), String.t(), String.t(), String.t()) ::
          result()
  def change_recovery_credential(client, user_id, password, question, answer) do
    Tesla.post(client, @users_url <> "/#{user_id}", %{
      credentials: Map.merge(password_data(password), recovery_data(question, answer))
    })
    |> Okta.result()
  end

  @doc """
  Activates a user

  This operation can only be performed on users with a STAGED status. Activation of a user is an asynchronous operation.

  The user's transitioningToStatus property has a value of ACTIVE during activation to indicate that the user hasn't completed the asynchronous operation.
  The user's status is ACTIVE when the activation process is complete.
  Users who don't have a password must complete the welcome flow by visiting the activation link to complete the transition to ACTIVE status.

  [https://developer.okta.com/docs/reference/api/users/#activate-user](https://developer.okta.com/docs/reference/api/users/#activate-user)
  """
  @spec activate_user(client(), String.t(), boolean()) :: result()
  def activate_user(client, user_id, send_email \\ false) do
    Tesla.post(
      client,
      @users_url <> "/#{user_id}/lifecycle/activate",
      "",
      query: [sendEmail: send_email]
    )
    |> Okta.result()
  end

  @doc """
  Reactivates a user

  This operation can only be performed on users with a PROVISIONED status. This operation restarts the activation workflow if for some reason the user activation was not completed when using the activationToken from Activate User.

  Users that don't have a password must complete the flow by completing Reset Password and MFA enrollment steps to transition the user to ACTIVE status.

  [https://developer.okta.com/docs/reference/api/users/#reactivate-user](https://developer.okta.com/docs/reference/api/users/#reactivate-user)
  """
  @spec reactivate_user(client(), String.t(), boolean()) :: result()
  def reactivate_user(client, user_id, send_email \\ false) do
    Tesla.post(
      client,
      @users_url <> "/#{user_id}/lifecycle/reactivate",
      "",
      query: [sendEmail: send_email]
    )
    |> Okta.result()
  end

  @doc """

  Deactivates a user

  This operation can only be performed on users that do not have a DEPROVISIONED status. Deactivation of a user is an asynchronous operation.

  The user's transitioningToStatus property is DEPROVISIONED during deactivation to indicate that the user hasn't completed the asynchronous operation.
  The user's status is DEPROVISIONED when the deactivation process is complete.

  [https://developer.okta.com/docs/reference/api/users/#deactivate-user](https://developer.okta.com/docs/reference/api/users/#deactivate-user)
  """
  @spec deactivate_user(client(), String.t(), boolean()) :: result()
  def deactivate_user(client, user_id, send_email \\ false) do
    Tesla.post(client, @users_url <> "/#{user_id}/lifecycle/deactivate", "",
      query: [sendEmail: send_email]
    )
    |> Okta.result()
  end

  @doc """
  Unlocks a user with a LOCKED_OUT status and returns them to ACTIVE status. Users will be able to login with their current password.

  [https://developer.okta.com/docs/reference/api/users/#unlock-user](https://developer.okta.com/docs/reference/api/users/#unlock-user)
  """
  @spec unlock_user(client(), String.t()) :: result()
  def unlock_user(client, user_id) do
    Tesla.post(client, @users_url <> "/#{user_id}/lifecycle/unlock", "") |> Okta.result()
  end

  @doc """
  This operation transitions the user status to PASSWORD_EXPIRED so that the user is required to change their password at their next login.

  If tempPassword is included in the request, the user's password is reset to a temporary password that is returned, and then the temporary password is expired.

  [https://developer.okta.com/docs/reference/api/users/#expire-password](https://developer.okta.com/docs/reference/api/users/#expire-password)
  """
  @spec expire_passsword(client(), String.t(), boolean()) :: result()
  def expire_passsword(client, user_id, temp_password \\ false) do
    Tesla.post(client, @users_url <> "/#{user_id}/lifecycle/expire_password", "",
      query: [tempPassword: temp_password]
    )
    |> Okta.result()
  end

  @doc """
  Generates a one-time token (OTT) that can be used to reset a user's password. The OTT link can be automatically emailed to the user or returned to the API caller and distributed using a custom flow.

  This operation will transition the user to the status of RECOVERY and the user will not be able to login or initiate a forgot password flow until they complete the reset flow.

  [https://developer.okta.com/docs/reference/api/users/#reset-password](https://developer.okta.com/docs/reference/api/users/#reset-password)
  """
  @spec reset_password(client(), String.t(), boolean()) :: result()
  def reset_password(client, user_id, send_email \\ false) do
    Tesla.post(
      client,
      @users_url <> "/#{user_id}" <> "/lifecycle/reset_password",
      "",
      query: [sendEmail: send_email]
    )
    |> Okta.result()
  end

  @doc """
  Suspends a user

  This operation can only be performed on users with an ACTIVE status. The user has a status of SUSPENDED when the process is complete.


  [https://developer.okta.com/docs/reference/api/users/#suspend-user](https://developer.okta.com/docs/reference/api/users/#suspend-user)
  """
  @spec suspend_user(client(), String.t()) :: result()
  def suspend_user(client, user_id) do
    Tesla.post(client, @users_url <> "/#{user_id}/lifecycle/suspend", "") |> Okta.result()
  end

  @doc """
  Unsuspends a user and returns them to the ACTIVE state

  [https://developer.okta.com/docs/reference/api/users/#unsuspend-user](https://developer.okta.com/docs/reference/api/users/#unsuspend-user)
  """
  @spec unsuspend_user(client(), String.t()) :: result()
  def unsuspend_user(client, user_id) do
    Tesla.post(client, @users_url <> "/#{user_id}/lifecycle/unsuspend", "") |> Okta.result()
  end

  @doc """
  Deletes a user permanently. This operation can only be performed on users that have a DEPROVISIONED status. This action cannot be recovered!

  [https://developer.okta.com/docs/reference/api/users/#delete-user](https://developer.okta.com/docs/reference/api/users/#delete-user)
  """
  @spec delete_user(client(), String.t(), boolean()) :: result()
  def delete_user(client, user_id, send_email \\ false) do
    Tesla.delete(client, @users_url <> "/#{user_id}", query: [sendEmail: send_email])
    |> Okta.result()
  end

  @doc """
  Generates a one-time token (OTT) that can be used to reset a user's password

  The user will be required to validate their security question's answer when visiting the reset link.
  This operation can only be performed on users with an ACTIVE status and a valid recovery question credential.

  [https://developer.okta.com/docs/reference/api/users/#forgot-password](https://developer.okta.com/docs/reference/api/users/#forgot-password)
  """
  @spec forgot_password(client(), String.t(), boolean()) :: result()
  def forgot_password(client, user_id, send_email \\ true) do
    Tesla.post(
      client,
      @users_url <> "/#{user_id}/credentials/forgot_password",
      "",
      query: [sendEmail: send_email]
    )
    |> Okta.result()
  end

  @doc """
  Sets a new password for a user by validating the user's answer to their current recovery question

  [https://developer.okta.com/docs/reference/api/users/#forgot-password](https://developer.okta.com/docs/reference/api/users/#forgot-password)
  """
  @spec forgot_password_with_security_answer(client(), String.t(), String.t(), String.t()) ::
          result()
  def forgot_password_with_security_answer(
        client,
        user_id,
        security_answer,
        new_password
      ) do
    Tesla.post(
      client,
      @users_url <> "/#{user_id}/credentials/forgot_password",
      %{password: %{value: new_password}, recovery_question: %{answer: security_answer}}
    )
    |> Okta.result()
  end

  defp recovery_data(question, answer),
    do: %{recovery_question: %{question: question, answer: answer}}

  defp password_data(password), do: %{password: %{value: password}}
end
