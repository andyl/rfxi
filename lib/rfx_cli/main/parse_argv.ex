defmodule RfxCli.Main.ParseArgv do
  @moduledoc false

  alias RfxCli.State
  alias RfxCli.Main.GenOptimus

  def test_run(state) when is_map(state) do 
    state
    |> State.new()
    |> GenOptimus.run()
    |> run()
  end

  def test_run(argv) when is_binary(argv) do
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

    parse_result =
      state.optimus_data
      |> Optimus.parse!(state.argv, haltfun)

    case parse_result do
      {:error, msg} -> {:error, msg}
      parse_data -> State.assign(state, :parse_result, parse_data)
    end
  end
end
