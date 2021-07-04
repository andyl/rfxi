defmodule RfxCli.Main.ExecuteCommand do
  @moduledoc false

  def run({:error, stage, msg}) do
    {:error, stage, msg}
  end

  def run(cmd_args) do
    case cmd_args[:launch_cmd] do
      :credo_repl -> 
        RfxCli.CredoRepl.start()
      :rfx_repl -> 
        RfxCli.Repl.start()
      :server -> 
        RfxCli.Server.start()
      _ -> 
        run_subcmd(cmd_args)
        |> run_convert(cmd_args)
        |> run_apply(cmd_args)
    end
  end

  def run_subcmd(cmd_args) do
    mod = cmd_args[:op_module]
    fun = cmd_args[:op_scope]
    arg = [cmd_args[:op_target], cmd_args[:op_args]]
    apply(mod, fun, arg) 
  end

  def run_convert(changeset, cmd_args) do
    case cmd_args[:op_convert] do
      [] -> changeset
      _ -> perform_convert(changeset, cmd_args)
    end
  end

  def run_apply(changeset, cmd_args) do
    case cmd_args[:op_apply] do
      true -> changeset |> Rfx.Change.Set.apply!()
      false -> changeset
    end
  end

  defp perform_convert(changeset, cmd_args) when is_list(cmd_args) do
    cmd_args[:op_convert]
    |> Enum.reduce(changeset, fn(el, acc) -> xconvert(el, acc) end)
  end

  defp xconvert(type, changelist) do
    mod = Rfx.Change.Set
    fun = :convert
    arg = [changelist, to_atom(type)]
    apply(mod, fun, arg)
  end

  defp to_atom(item) when is_binary(item) do
    String.to_atom(item)
  end

  defp to_atom(item) when is_atom(item) do
    item
  end

end
