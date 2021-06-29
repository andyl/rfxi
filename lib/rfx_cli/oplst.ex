defmodule RfxCli.Oplst do

  alias Rfx.Util.OpInfo

  @moduledoc """
  Return a list of subcommands.
  """

  def proto_ops do
    Rfx.Catalog.OpsCat.select_ops("Proto")
  end

  def all_ops do
    Rfx.Catalog.OpsCat.all_ops()
  end

  def subcommands(list \\ all_ops()) do 
    RfxCli.Argspec.base_subcommands() ++
      Enum.map(list, &option_block/1) 
  end

  def option_block(module) do
    keylist = [
      name: OpInfo.name(module),
      description: """
      """
    ] ++ merged_options(module)
    { OpInfo.key(module), keylist }
  end

  def module_options(module) do
    OpInfo.argspec(module)
  end

  def common_options do
    RfxCli.Argspec.subcommand_options()
  end

  def merged_options(module) do
    vsn1 = module_options(module) ++ [args: common_options()[:args]]
    copt = common_options()[:options] 
    cflg = common_options()[:flags] || []
    opts = (vsn1[:options] || []) ++ copt 
    flgs = (vsn1[:flags] || []) ++ cflg
    vsn2 = Keyword.delete(vsn1, :options)
    vsn3 = vsn2 ++ [options: opts] ++ [flags: flgs]
    vsn3
  end

end
