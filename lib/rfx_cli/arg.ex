defmodule RfxCli.Arg do
  @moduledoc """
  Return an Optimius data structure, for ARGV parsing and processing.

  Data structure is assembled from
  - Base Config (base configuration and global flags)
  - Base Subcommands (Repl, Server, ...)
  - Operation Subcommands (one for each Rfx Operation)
  - Operation Config (applied to each Operation Subcommand)
  """

  alias RfxCli.ArgSpec
  alias RfxCli.ArgOps

  def build(state) do
    state
    |> gen_token()
    |> gen_optimus(state)
  end

  def gen_token(state) do
    %{
      state: state, 
      base_config: ArgSpec.base_config(), 
      base_subcommands: ArgSpec.base_subcommands(), 
      operation_config: ArgSpec.operation_config(), 
      operation_subcommands: ArgOps.subcommands()
    }
  end

  def gen_optimus(token, state) do 
    token.base_config ++ [subcommands: subcoms(token, state)]
  end

  defp subcoms(token, %{in_repl?: true}), do: token.operation_subcommands
  defp subcoms(token, %{in_repl?: false}), do: token.base_subcommands ++ token.operation_subcommands

end
