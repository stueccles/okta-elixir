# Okta

[![Elixir CI](https://github.com/stueccles/okta-elixir/actions/workflows/elixir.yml/badge.svg)](https://github.com/stueccles/okta-elixir/actions/workflows/elixir.yml)
[![Module Version](https://img.shields.io/hexpm/v/okta_api.svg)](https://hex.pm/packages/okta_api)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/okta_api/)
[![Total Download](https://img.shields.io/hexpm/dt/okta_api.svg)](https://hex.pm/packages/okta_api)
[![License](https://img.shields.io/hexpm/l/okta_api.svg)](https://github.com/variance-inc/okta-elixir/blob/master/LICENSE.md)
[![Last Updated](https://img.shields.io/github/last-commit/variance-inc/okta-elixir.svg)](https://github.com/variance-inc/okta-elixir/commits/master)

<!-- MDOC !-->

This library provides an Elixir API for accessing the [Okta Developer APIs](https://developer.okta.com/docs/reference/).

Currently implemented are:

- [Users API](https://developer.okta.com/docs/reference/api/users/)
- [Groups API](https://developer.okta.com/docs/reference/api/groups/)
- [Apps API](https://developer.okta.com/docs/reference/api/apps/)
- [Trusted Origins API](https://developer.okta.com/docs/reference/api/trusted-origins/)
- [Identity Provider API](https://developer.okta.com/docs/reference/api/idps/)
- [Event Hook Handler](https://developer.okta.com/docs/concepts/event-hooks/)
- [Okta OpenID Connect & OAuth 2.0 API](https://developer.okta.com/docs/reference/api/oidc/)

The API access uses the [Tesla](https://github.com/teamon/tesla) library and
relies on the caller passing in an Okta base URL and an API Key to create a
client. The client is then passed into all API calls.

The API returns a 3 element tuple. If the API HTTP status code is less
the 300 (ie. succeeded) it returns `:ok`, the HTTP body as a map and the full
Tesla Env if you need to access more data about the return. if the API HTTP
status code is greater than 300. it returns `:error`, the HTTP body and the
Telsa Env. If the API doesn't return at all it should return `:error`, a blank
map and the error from Tesla.

```elixir

client = Okta.client("https://dev-000000.okta.com", "thisismykeycreatedinokta")

profile = %{
  firstName: "test",
  lastName: "user",
}

case Okta.Users.create_user(client, profile) do
  {:ok, %{"id" => id, "status" => status}, _env} ->
    update_user(%{okta_id: id, okta_status: status})
  {:error, %{"errorSummary" => errorSummary}, _env} ->
    Logger.error(errorSummary)
end
```
<!-- MDOC !-->

## Installation

The package can be installed by adding `:okta` to your list of dependencies in
`mix.exs`:

```elixir
def deps do
  [
    {:okta_api, "~> 0.1.14"},
  ]
end
```

## Copyright and License

Copyright (c) 2019 Variance

This work is free. You can redistribute it and/or modify it under the
terms of the MIT License. See the [LICENSE.md](./LICENSE.md) file for more details.
