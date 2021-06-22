defmodule RfxCli.Server do
  def start() do
    # We configure the endpoint with `server: true`,
    # so it's gonna start listening
    Logger.configure(level: :debug)
    set_config()
    IO.puts("STARTING SERVER")
    IO.puts("Ctrl-C to exit...")
    IO.inspect(Application.stop(:rfxi))
    IO.inspect(Rfxi.Application.start())
    Process.sleep(:infinity)
  end

  defp set_config do
    args = Application.get_env(:rfxi, RfxiWeb.Endpoint) ++ [server: true]
    Application.put_env(:rfxi, RfxiWeb.Endpoint, args)
  end
end
