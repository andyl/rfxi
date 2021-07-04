defmodule RfxCli.CredoRepl do

  def start do
    loop("begin", %{count: 1})
  end

  def start(state) do 
    loop("begin", state)
  end

  def loop("begin", state) do
    IO.puts("STARTING CREDO REPL")

    if Application.get_env(:rfxi, :env) != :test do
      loop(:ok, state)
    end
  end

  def loop(_, state) do
    command = get_input(state.count)

    case run(command) do
      :halt -> IO.puts("DONE")
      _ -> loop("continue", %{state | count: state.count + 1})
    end
  end

  defp get_input(count) do
    IO.gets("rfx_credo_repl_#{count}> ")
    |> String.trim()
  end

  defp run("") do
    :no_cmd
  end

  defp run("exit") do
    :halt
  end

  defp run(command) do
    RfxCli.Base.main(command)
  end
end
