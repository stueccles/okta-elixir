ExUnit.start()

Mox.defmock(
  Okta.Tesla.Mock,
  for: Tesla.Adapter
)

Mox.defmock(
  EventHookHandlerMock,
  for: Okta.EventHookHandler
)
