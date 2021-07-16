defmodule RfxCli.ArgOps do
  alias Rfx.Util.OpInfo

  @moduledoc """
  Return Optimus config for Rfx Operations.
  """

  def subcommands do
    Rfx.Catalog.OpsCat.all_ops()
    |> subcommands()
  end

  def subcommands(query) when is_binary(query) do
    Rfx.Catalog.OpsCat.select_ops(query)
    |> subcommands()
  end

  def subcommands(list) when is_list(list) do
    list
    |> Enum.map(&option_block/1)
  end

  defp option_block(module) do
    keylist =
      [
        name: OpInfo.name(module),
        description: """
        """
      ] ++ merged_options(module)

    {OpInfo.key(module), keylist}
  end

  defp merged_options(module) do
    # [args: args, flags: flags, options: options] = RfxCli.ArgSpec.operation_config()
    #
    # module_options(module) ++ [
    #   args: args, 
    #   options: options, 
    #   flags: flags
    # ]

    module_options(module) ++ RfxCli.ArgSpec.operation_config()
  end

  defp module_options(module) do
    OpInfo.propspec(module)
  end
end
