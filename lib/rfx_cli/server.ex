defmodule RfxCli.Server do
  def start() do
    # We configure the endpoint with `server: true`,
    # so it's gonna start listening
    IO.puts("STARTING SERVER")
    case Application.ensure_all_started(:rfxi) do
      {:ok, _} -> :ok
      {:error, _} -> :error
    end
  end
end
