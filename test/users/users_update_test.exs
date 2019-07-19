defmodule Okta.UsersUpdateTest do
  use ExUnit.Case
  doctest Okta.Users

  setup do
    base_url = "https://dev-000000.okta.com"
    token = "ssws_token"
    user_id = "user123124"
    client = Okta.client(base_url, token)
    {:ok, %{client: client, base_url: base_url, token: token, user_id: user_id}}
  end

  test "clear_user_sessions/2 requests correctly", %{
    client: client,
    base_url: base_url,
    user_id: user_id
  } do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert :delete == request.method
        assert "#{base_url}/api/v1/users/#{user_id}" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} = Okta.Users.clear_user_sessions(client, user_id)
  end

  test "set_password/3 requests correctly", %{
    client: client,
    base_url: base_url,
    user_id: user_id
  } do
    password = "set_password"

    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        {:ok, expected_body} = Jason.encode(%{credentials: %{password: %{value: password}}})
        assert expected_body == request.body
        assert :post == request.method
        assert "#{base_url}/api/v1/users/#{user_id}" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} = Okta.Users.set_password(client, user_id, password)
  end

  test "change_password/4 requests correctly", %{
    client: client,
    base_url: base_url,
    user_id: user_id
  } do
    old_password = "set_password"
    new_password = "change_password"

    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        {:ok, expected_body} =
          Jason.encode(%{
            credentials: %{
              oldPassword: %{value: old_password},
              newPassword: %{value: new_password}
            }
          })

        assert expected_body == request.body
        assert :post == request.method
        assert "#{base_url}/api/v1/users/#{user_id}" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} = Okta.Users.change_password(client, user_id, old_password, new_password)
  end

  test "set_recovery_credential/4 requests correctly", %{
    client: client,
    base_url: base_url,
    user_id: user_id
  } do
    question = "What was you first dog's name?"
    answer = "Okta"

    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        {:ok, expected_body} =
          Jason.encode(%{credentials: %{recovery_question: %{question: question, answer: answer}}})

        assert expected_body == request.body
        assert :put == request.method
        assert "#{base_url}/api/v1/users/#{user_id}" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} = Okta.Users.set_recovery_credential(client, user_id, question, answer)
  end

  test "change_recovery_credential/5 requests correctly", %{
    client: client,
    base_url: base_url,
    user_id: user_id
  } do
    password = "set_password"
    question = "What was you first dog's name?"
    answer = "Okta"

    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        {:ok, expected_body} =
          Jason.encode(%{
            credentials: %{
              password: %{value: password},
              recovery_question: %{question: question, answer: answer}
            }
          })

        assert expected_body == request.body
        assert :post == request.method
        assert "#{base_url}/api/v1/users/#{user_id}" == request.url
        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} =
             Okta.Users.change_recovery_credential(client, user_id, password, question, answer)
  end

  test "activate_user/2 requests correctly", %{
    client: client,
    base_url: base_url,
    user_id: user_id
  } do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert :post == request.method
        assert [sendEmail: false] == request.query

        assert "#{base_url}/api/v1/users/#{user_id}/lifecycle/activate" ==
                 request.url

        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} = Okta.Users.activate_user(client, user_id)
  end

  test "activate_user/3 requests correctly", %{
    client: client,
    base_url: base_url,
    user_id: user_id
  } do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert :post == request.method
        assert [sendEmail: true] == request.query

        assert "#{base_url}/api/v1/users/#{user_id}/lifecycle/activate" ==
                 request.url

        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} = Okta.Users.activate_user(client, user_id, true)
  end

  test "deactivate_user/2 requests correctly", %{
    client: client,
    base_url: base_url,
    user_id: user_id
  } do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert :post == request.method

        assert "#{base_url}/api/v1/users/#{user_id}/lifecycle/deactivate" ==
                 request.url

        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} = Okta.Users.deactivate_user(client, user_id)
  end

  test "unlock_user/2 requests correctly", %{
    client: client,
    base_url: base_url,
    user_id: user_id
  } do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert :post == request.method

        assert "#{base_url}/api/v1/users/#{user_id}/lifecycle/unlock" ==
                 request.url

        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} = Okta.Users.unlock_user(client, user_id)
  end

  test "expire_passsword/2 requests correctly", %{
    client: client,
    base_url: base_url,
    user_id: user_id
  } do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert :post == request.method
        assert [tempPassword: false] == request.query

        assert "#{base_url}/api/v1/users/#{user_id}/lifecycle/expire_password" ==
                 request.url

        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} = Okta.Users.expire_passsword(client, user_id)
  end

  test "expire_passsword/3 requests correctly", %{
    client: client,
    base_url: base_url,
    user_id: user_id
  } do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert :post == request.method
        assert [tempPassword: true] == request.query

        assert "#{base_url}/api/v1/users/#{user_id}/lifecycle/expire_password" ==
                 request.url

        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} = Okta.Users.expire_passsword(client, user_id, true)
  end

  test "reset_password/2 requests correctly", %{
    client: client,
    base_url: base_url,
    user_id: user_id
  } do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert :post == request.method
        assert [sendEmail: false] == request.query

        assert "#{base_url}/api/v1/users/#{user_id}/lifecycle/reset_password" ==
                 request.url

        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} = Okta.Users.reset_password(client, user_id)
  end

  test "reset_password/3 requests correctly", %{
    client: client,
    base_url: base_url,
    user_id: user_id
  } do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert :post == request.method
        assert [sendEmail: true] == request.query

        assert "#{base_url}/api/v1/users/#{user_id}/lifecycle/reset_password" ==
                 request.url

        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} = Okta.Users.reset_password(client, user_id, true)
  end

  test "suspend_user/2 requests correctly", %{
    client: client,
    base_url: base_url,
    user_id: user_id
  } do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert :post == request.method

        assert "#{base_url}/api/v1/users/#{user_id}/lifecycle/suspend" ==
                 request.url

        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} = Okta.Users.suspend_user(client, user_id)
  end

  test "unsuspend_user/2 requests correctly", %{
    client: client,
    base_url: base_url,
    user_id: user_id
  } do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert :post == request.method

        assert "#{base_url}/api/v1/users/#{user_id}/lifecycle/unsuspend" ==
                 request.url

        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} = Okta.Users.unsuspend_user(client, user_id)
  end

  test "forgot_password/2 requests correctly", %{
    client: client,
    base_url: base_url,
    user_id: user_id
  } do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert :post == request.method
        assert [sendEmail: true] == request.query

        assert "#{base_url}/api/v1/users/#{user_id}/credentials/forgot_password" ==
                 request.url

        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} = Okta.Users.forgot_password(client, user_id)
  end

  test "forgot_password/3 requests correctly", %{
    client: client,
    base_url: base_url,
    user_id: user_id
  } do
    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        assert :post == request.method
        assert [sendEmail: false] == request.query

        assert "#{base_url}/api/v1/users/#{user_id}/credentials/forgot_password" ==
                 request.url

        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} = Okta.Users.forgot_password(client, user_id, false)
  end

  test "forgot_password_with_security_answer/4 requests correctly", %{
    client: client,
    base_url: base_url,
    user_id: user_id
  } do
    new_password = "forgot_password_with_security_answer"
    answer = "Okta"

    Okta.Tesla.Mock
    |> Mox.expect(:call, fn
      request, _opts ->
        {:ok, expected_body} =
          Jason.encode(%{
            password: %{value: new_password},
            recovery_question: %{answer: answer}
          })

        assert expected_body == request.body
        assert :post == request.method

        assert "#{base_url}/api/v1/users/#{user_id}/credentials/forgot_password" ==
                 request.url

        {:ok, Tesla.Mock.json(%{}, status: 200)}
    end)

    assert {:ok, result} =
             Okta.Users.forgot_password_with_security_answer(
               client,
               user_id,
               answer,
               new_password
             )
  end
end
