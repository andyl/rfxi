defmodule RfxCli.Oplst do

  alias Rfx.Catalog
  alias Rfx.Util.OpInfo

  def proto do
    Catalog.select("Proto")
  end

  def subcommands(list \\ proto()) do
    list
    |> Enum.map(&option_block/1)
  end

  def option_block(module) do
    keylist = [
      {:name, OpInfo.name(module)}
    ] ++ merged_options(module)
    { OpInfo.key(module), keylist }
  end

  def module_options(module) do
    OpInfo.argspec(module)
  end

  def common_options do
    [
      args: [
        target: [
          value_name: "TARGET",
          help: "Refactoring target",
          required: true,
          parser: :string
        ]
      ],
      options: [
        scope: [
          short: "-s",
          long: "--scope",
          value_name: "SCOPE",
          help: "Refactoring scope",
          parser: :string
        ], 
        changeset: [
          short: "-c",
          long: "--changeset",
          value_name: "CHANGESET",
          help: "Output format",
          parser: :string
        ]
      ]
    ]
  end

  def merged_options(module) do
    vsn1 = module_options(module) ++ [args: common_options()[:args]]
    copt = common_options()[:options] 
    opts = (vsn1[:options] || []) ++ copt 
    vsn2 = Keyword.delete(vsn1, :options)
    vsn3 = vsn2 ++ [options: opts]
    vsn3
  end

end
