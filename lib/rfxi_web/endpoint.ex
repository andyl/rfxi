defmodule RfxiWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :rfxi

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_rfxi_key",
    signing_salt: "Bps/fnJq"
  ]

  socket "/socket", RfxiWeb.UserSocket,
    websocket: true,
    longpoll: false

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # -------------------------------------------------------------

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  # plug Plug.Static,
  #   at: "/",
  #   from: :rfxi,
  #   gzip: false,
  #   only: ~w(css fonts images js favicon.ico robots.txt)

  # -------------------------------------------------------------

  # We use Escript for distributing Livebook, so we don't
  # have access to the files in priv/static at runtime in the prod environment.
  # To overcome this we load contents of those files at compilation time,
  # so that they become a part of the executable and can be served from memory.
  defmodule AssetsMemoryProvider do
    use RfxiWeb.MemoryProvider,
      from: :rfxi,
      gzip: true
  end

  defmodule AssetsFileSystemProvider do
    use RfxiWeb.FileSystemProvider,
      from: "tmp/static_dev"
  end

  # Serve static failes at "/"

  if code_reloading? do
    # In development we use assets from tmp/static_dev (rebuilt dynamically on
    # every change).  Note that this directory doesn't contain predefined files
    # (e.g. images), so we also use `AssetsMemoryProvider` to serve those from
    # priv/static.
    plug Plug.Static,
      at: "/",
      from: :rfxi,
      gzip: false,
      only: ~w(css fonts images js rfx_icon.svg favicon.ico robots.txt)
  else
    plug RfxiWeb.StaticPlug,
      at: "/",
      file_provider: AssetsMemoryProvider,
      gzip: true
  end

  # -------------------------------------------------------------

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug RfxiWeb.Router
end
