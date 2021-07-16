defmodule RfxCli.Main.ExtractCommand do
  @moduledoc """
  Converts Optimus parse data into a command_args list.

  The command_args list contains the following elements:

  ```elixir
  [
    launch_cmd: <cmd_name: atom>
    launch_args: struct
    op_module: <module_name: string>
    op_scope: <code | file | project | subapp | tmpfile>
    op_target: <scope target: code | filepath | dirpath>
    op_args: <keyword list with operation arguments ([])>
    op_convert: <string - comma-separated list of conversions>
    op_apply: boolean (false)
    op_quiet: boolean (false)
    op_oneline: boolean (false)
  ]
  """

  alias RfxCli.State

  def run({:error, msg}) do
    {:error, msg}
  end

  def run(state) do  
    case extract(state.parse_result) do
      {:error, msg} -> {:error, msg}
      result -> State.assign(state, :command_args, result)
    end
  end

  # This pattern is expressed when a subcommand is used.
  def extract({[subcmd], parse = %Optimus.ParseResult{}}) do
    Keyword.merge(default_args(), subcmd_args(subcmd, parse))
  end

  # This pattern is expressed when no subcommand is used (eg "rfx --help")
  def extract(parse = %Optimus.ParseResult{}) do
    Keyword.merge(default_args(), cmd_args(parse))
  end

  defp cmd_args(_parse) do
    raise "CMD ARG ERROR"
    [
      # launch_repl: Map.fetch!(parse, :flags)[:repl],
      # launch_server: Map.fetch!(parse, :flags)[:server]
    ] 
  end

  defp subcmd_args(cmd, parse) do
    commands = [ :repl, :pipe, :server ]
    case Enum.member?(commands, cmd) do
      true -> [launch_cmd: cmd, launch_args: parse]
      false -> subop_args(cmd, parse)
    end
  end

  defp subop_args(subcmd, parse) do
    sub = subcmd |> Atom.to_string() |> String.replace("_", ".")
    mod = ("Elixir.Rfx.Ops." <> sub) |> String.to_atom()
    fun = set_scope(parse) |> String.to_atom()
    tgt = Map.fetch!(parse, :args)[:target] || ""
    arg = args_for(parse)
    con = converts_for(parse)
    [
      op_module: mod, 
      op_scope: fun,
      op_target: tgt, 
      op_args: arg,
      op_convert: con, 
      op_apply: Map.fetch!(parse, :flags)[:apply], 
      op_quiet: Map.fetch!(parse, :flags)[:quiet],
      op_oneline: Map.fetch!(parse, :flags)[:oneline]
    ]
  end

  defp set_scope(parse_data) do
    scope = Map.fetch!(parse_data, :options)[:scope]
    target = Map.fetch!(parse_data, :args)[:target]

    case scope do
      nil -> RfxCli.Util.InferScope.for(target)
      "code" -> "cl_code"
      "file" -> "cl_file"
      "project" -> "cl_project"
      "subapp" -> "cl_subapp"
      "tmpfile" -> "cl_tmpfile"
      _ -> raise("Error: unknown scope (#{scope})")
    end
  end

  defp converts_for(parse_data) do
    parse_data
    |> Map.fetch!(:options)
    |> Map.get(:convert, "") 
    |> split()
    |> Enum.map(&String.to_atom/1)
  end

  defp split(nil) do
    []
  end

  defp split(string) do
    String.split(string, ",")
  end

  defp args_for(parse_data) do
    parse_data
    |> Map.fetch!(:options)
    |> Map.delete(:changelist)
    |> Map.delete(:convert)
    |> Map.delete(:scope)
    |> Keyword.new()
  end

  defp launch_args do 
    [
      launch_cmd: nil,
      launch_args: nil,
    ]
  end

  defp op_args do 
    [
      op_module: nil,
      op_scope: nil,
      op_target: nil,
      op_args: nil,
      op_convert: nil, 
      op_apply: false,
      op_quiet: false, 
      op_oneline: false
    ]
  end

  defp default_args do
    launch_args() ++ op_args()
  end
end
