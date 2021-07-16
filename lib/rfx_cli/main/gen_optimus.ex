defmodule RfxCli.Main.GenOptimus do
  @moduledoc false

  alias RfxCli.State

  def run(argv) when is_binary(argv) do
    %{argv: OptionParser.split(argv)}
    |> State.new()
    |> run()
  end

  def run({:error, msg}) do 
    {:error, msg}
  end

  def run(state) do
    optimus =
      state
      |> RfxCli.Arg.build()
      |> Optimus.new()

    case optimus do
      {:error, msg} -> {:error, msg}
      {:ok, optimus} -> State.assign(state, :optimus_data, optimus)
    end
  end

end
