# Okta

This library provides an Elixir API for accessing the [Okta Developer APIS](https://developer.okta.com/docs/reference/).

Currently implemented are:
* [Users API](https://developer.okta.com/docs/reference/api/users/)
* [Groups API](https://developer.okta.com/docs/reference/api/groups/)

The API access uses the [Tesla](https://github.com/teamon/tesla) library and relies on the caller passing in an Okta base URL and an API Key
to create a client

```
  client = Okta.Client("https://dev-000000.okta.com", "thisismykeycreatedinokta")

  {:ok, result} = Okta.Users.list_users(client)
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `okta` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:okta, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/okta](https://hexdocs.pm/okta).

