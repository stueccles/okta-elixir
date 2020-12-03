defmodule Okta.UsersUpdateTest do
  use ExUnit.Case
  alias Okta.TestSupport.Helpers
  doctest Okta.Users

  setup do
    token = "ssws_token"
    user_id = "user123124"
    client = Okta.client(Helpers.base_url(), token)
    {:ok, %{client: client, token: token, user_id: user_id}}
  end

  test "clear_user_sessions/2 requests correctly", %{
    client: client,
    user_id: user_id
  } do
    Helpers.mock_request(
      path: "/api/v1/users/#{user_id}/sessions",
      method: :delete,
      query: [oauthTokens: false],
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.clear_user_sessions(client, user_id)
  end

  test "set_password/3 requests correctly", %{
    client: client,
    user_id: user_id
  } do
    password = "set_password"

    Helpers.mock_request(
      path: "/api/v1/users/#{user_id}",
      method: :post,
      body: Jason.encode!(%{credentials: %{password: %{value: password}}}),
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.set_password(client, user_id, password)
  end

  test "change_password/4 requests correctly", %{
    client: client,
    user_id: user_id
  } do
    old_password = "set_password"
    new_password = "change_password"

    Helpers.mock_request(
      path: "/api/v1/users/#{user_id}/credentials/change_password",
      method: :post,
      query: [strict: false],
      body:
        Jason.encode!(%{
          oldPassword: %{value: old_password},
          newPassword: %{value: new_password}
        }),
      status: 200
    )

    assert {:ok, %{}, _env} =
             Okta.Users.change_password(client, user_id, old_password, new_password)
  end

  test "set_recovery_credential/4 requests correctly", %{
    client: client,
    user_id: user_id
  } do
    question = "What was you first dog's name?"
    answer = "Okta"

    Helpers.mock_request(
      path: "/api/v1/users/#{user_id}",
      method: :put,
      body:
        Jason.encode!(%{credentials: %{recovery_question: %{question: question, answer: answer}}}),
      status: 200
    )

    assert {:ok, %{}, _env} =
             Okta.Users.set_recovery_credential(client, user_id, question, answer)
  end

  test "change_recovery_credential/5 requests correctly", %{
    client: client,
    user_id: user_id
  } do
    password = "set_password"
    question = "What was you first dog's name?"
    answer = "Okta"

    Helpers.mock_request(
      path: "/api/v1/users/#{user_id}/credentials/change_recovery_question",
      method: :post,
      body:
        Jason.encode!(%{
          credentials: %{
            password: %{value: password},
            recovery_question: %{question: question, answer: answer}
          }
        }),
      status: 200
    )

    assert {:ok, %{}, _env} =
             Okta.Users.change_recovery_credential(client, user_id, password, question, answer)
  end

  test "activate_user/2 requests correctly", %{
    client: client,
    user_id: user_id
  } do
    Helpers.mock_request(
      path: "/api/v1/users/#{user_id}/lifecycle/activate",
      method: :post,
      query: [sendEmail: false],
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.activate_user(client, user_id)
  end

  test "activate_user/3 requests correctly", %{
    client: client,
    user_id: user_id
  } do
    Helpers.mock_request(
      path: "/api/v1/users/#{user_id}/lifecycle/activate",
      method: :post,
      query: [sendEmail: true],
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.activate_user(client, user_id, true)
  end

  test "deactivate_user/2 requests correctly", %{
    client: client,
    user_id: user_id
  } do
    Helpers.mock_request(
      path: "/api/v1/users/#{user_id}/lifecycle/deactivate",
      method: :post,
      query: [sendEmail: false],
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.deactivate_user(client, user_id)
  end

  test "unlock_user/2 requests correctly", %{
    client: client,
    user_id: user_id
  } do
    Helpers.mock_request(
      path: "/api/v1/users/#{user_id}/lifecycle/unlock",
      method: :post,
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.unlock_user(client, user_id)
  end

  test "expire_passsword/2 requests correctly", %{
    client: client,
    user_id: user_id
  } do
    Helpers.mock_request(
      path: "/api/v1/users/#{user_id}/lifecycle/expire_password",
      method: :post,
      query: [tempPassword: false],
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.expire_passsword(client, user_id)
  end

  test "expire_passsword/3 requests correctly", %{
    client: client,
    user_id: user_id
  } do
    Helpers.mock_request(
      path: "/api/v1/users/#{user_id}/lifecycle/expire_password",
      method: :post,
      query: [tempPassword: true],
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.expire_passsword(client, user_id, true)
  end

  test "reset_password/2 requests correctly", %{
    client: client,
    user_id: user_id
  } do
    Helpers.mock_request(
      path: "/api/v1/users/#{user_id}/lifecycle/reset_password",
      method: :post,
      query: [sendEmail: false],
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.reset_password(client, user_id)
  end

  test "reset_password/3 requests correctly", %{
    client: client,
    user_id: user_id
  } do
    Helpers.mock_request(
      path: "/api/v1/users/#{user_id}/lifecycle/reset_password",
      method: :post,
      query: [sendEmail: true],
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.reset_password(client, user_id, true)
  end

  test "suspend_user/2 requests correctly", %{
    client: client,
    user_id: user_id
  } do
    Helpers.mock_request(
      path: "/api/v1/users/#{user_id}/lifecycle/suspend",
      method: :post,
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.suspend_user(client, user_id)
  end

  test "unsuspend_user/2 requests correctly", %{
    client: client,
    user_id: user_id
  } do
    Helpers.mock_request(
      path: "/api/v1/users/#{user_id}/lifecycle/unsuspend",
      method: :post,
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.unsuspend_user(client, user_id)
  end

  test "forgot_password/2 requests correctly", %{
    client: client,
    user_id: user_id
  } do
    Helpers.mock_request(
      path: "/api/v1/users/#{user_id}/credentials/forgot_password",
      method: :post,
      query: [sendEmail: true],
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.forgot_password(client, user_id)
  end

  test "forgot_password/3 requests correctly", %{
    client: client,
    user_id: user_id
  } do
    Helpers.mock_request(
      path: "/api/v1/users/#{user_id}/credentials/forgot_password",
      method: :post,
      query: [sendEmail: false],
      status: 200
    )

    assert {:ok, %{}, _env} = Okta.Users.forgot_password(client, user_id, false)
  end

  test "forgot_password_with_security_answer/4 requests correctly", %{
    client: client,
    user_id: user_id
  } do
    new_password = "forgot_password_with_security_answer"
    answer = "Okta"

    Helpers.mock_request(
      path: "/api/v1/users/#{user_id}/credentials/forgot_password",
      method: :post,
      body:
        Jason.encode!(%{
          password: %{value: new_password},
          recovery_question: %{answer: answer}
        }),
      status: 200
    )

    assert {:ok, %{}, _env} =
             Okta.Users.forgot_password_with_security_answer(
               client,
               user_id,
               answer,
               new_password
             )
  end
end
