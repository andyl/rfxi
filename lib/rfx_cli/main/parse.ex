defmodule RfxCli.Main.Parse do
  @moduledoc false

  def run(argv) when is_binary(argv) do
    %{argv: String.split(argv, " ")}
    |> RfxCli.State.new()
    |> run()
  end

  def run(state) do
    argv = state.argv
    haltfun = fn _ -> {:error, :halt} end
    propspec = RfxCli.Argspec.gen()
    optimus = propspec |> Optimus.parse!(argv, haltfun)

    case optimus do
      {:error, msg} -> {:error, msg}
      parse_data -> parse_data
    end
  end

end
