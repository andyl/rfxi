defmodule RfxCli.State do
  @moduledoc """
  Defines a state token that is used by the command-line parser.

  The state is used by the pipeline in RfxCli.Main module.

  Fields:
  - in_repl?     / is the CLI running from within the Repl?
  - argv         / the command-line input
  - optimus_data / results from the Optimus.new! function
  - parse_result / parse(argv, optimus_data) -> parse_result
  - command_args / the result of the Optimus parse function
  - changeset    / the results of the Rfx operation
  - json         / changeset converted to JSON

  """
  def new do 
    new(%{})
  end 

  def new(initial_state) do 
    %{
      in_repl?: false,
      argv: nil,
      optimus_data: nil, 
      parse_result: nil,
      command_args: nil, 
      changeset: nil,
      json: nil
    }
    |> Map.merge(initial_state)
  end 

  def assign(state, field, value) do
    Map.merge(state, %{field => value})
  end
end
