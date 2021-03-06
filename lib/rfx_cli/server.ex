defmodule RfxCli.Server do

  def main(_) do
    start()
  end

  def start() do
    # We configure the endpoint with `server: true`,
    # so it's gonna start listening
    # Logger.configure(level: :debug)
    Logger.configure(level: :info)
    set_config()
    IO.puts("STARTING SERVER")
    IO.puts("Ctrl-C to exit...")
    if Application.get_env(:rfxi, :env) != :test do
      Application.stop(:rfxi)
      IO.inspect(Rfxi.Application.start([], []))
      Process.sleep(:infinity)
    end
  end

  defp set_config do
    args = Application.get_env(:rfxi, RfxiWeb.Endpoint) ++ [server: true]
    Application.put_env(:rfxi, RfxiWeb.Endpoint, args)
  end

  # to be used by the CLI - send notifications the server if it is active
  def find_port(port) do
    case :gen_tcp.listen(port, []) do
      {:ok, socket} ->
        :gen_tcp.close(socket)
        port
      {:error, :eaddrinuse} ->
        find_port(port + 1)
    end
  end
end
