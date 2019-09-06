defmodule Okta.TestSupport.Helpers do
  @moduledoc false
  import ExUnit.Assertions

  def mock_request(opts) do
    mock_request(base_url(), opts)
  end

  def mock_request(base_url, opts, callback \\ nil) do
    status = Keyword.get(opts, :status)
    path = Keyword.get(opts, :path)
    method = Keyword.get(opts, :method)
    query = Keyword.get(opts, :query, [])
    response = Keyword.get(opts, :response, %{})
    body = Keyword.get(opts, :body)

    Mox.expect(Okta.Tesla.Mock, :call, fn
      request, _opts ->
        assert(request.body == body)
        assert(request.method == method)
        assert(request.query == query)
        assert(request.url == base_url <> path)

        if callback do
          callback.()
        end

        {:ok, Tesla.Mock.json(response, status: status)}
    end)
  end

  def base_url do
    "https://dev-000000.okta.com"
  end
end
