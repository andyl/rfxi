defmodule RfxCli.State do
  def new do 
    new(%{})
  end 

  def new(initial_state) do 
    %{
      argv: nil,
      parse: nil,
      cmd_args: nil,
      changeset: nil,
      repl_mode: false,
      json: nil
    }
    |> Map.merge(initial_state)
  end 
end
