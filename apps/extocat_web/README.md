# ExtocatWeb

This is the web delivery mechanism for the Extocat Scoring Service. It encapsulates the web-specific logic.

## Application configuration

  * `:debug_errors` - when `true`, uses `Plug.Debugger` functionality for debugging failures in the application. Recommended to be set to `true` only in development as it allows listing of the application source code during debugging. Defaults to `false`.

  * `:force_ssl` - when `true`, ensures no data is ever sent via HTTP, always redirecting to HTTPS. It sets the "strict-transport-security" header in HTTPS requests, forcing browsers to always use HTTPS. Defaults to `false`.

  * `:port` - the port used to run the server.

  * `:scheme` - either `:http` or `:https`.
