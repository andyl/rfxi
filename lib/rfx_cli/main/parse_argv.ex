defmodule RfxCli.Main.ParseArgv do
  @moduledoc false

  alias RfxCli.State
  alias RfxCli.Main.GenOptimus

  def run(argv) when is_binary(argv) do
    %{argv: OptionParser.split(argv)}
    |> State.new()
    |> GenOptimus.run()
    |> run()
  end

  def run({:error, msg}) do 
    {:error, msg}
  end

  def run(state) do
    haltfun = fn _ -> {:error, :halt} end

    optimus =
      state.optimus_data
      |> Optimus.parse!(state.argv, haltfun)

    case optimus do
      {:error, msg} -> {:error, msg}
      parse_data -> State.assign(state, :parse_result, parse_data)
    end
  end
end
