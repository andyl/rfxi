defmodule RfxCli.Main.ExecuteCommand do
  @moduledoc false

  def run({:error, stage, msg}) do
    {:error, stage, msg}
  end

  def run(cmd_args) do
    cond do
      cmd_args[:launch_repl] -> 
        RfxCli.Repl.start()
      cmd_args[:launch_server] -> 
        RfxCli.Server.start()
      true -> 
        run_subcmd(cmd_args)
        |> run_convert(cmd_args)
        |> run_apply(cmd_args)
    end
  end

  def run_subcmd(cmd_args) do
    mod = cmd_args[:op_module]
    fun = cmd_args[:op_scope]
    arg = [cmd_args[:op_target], cmd_args[:op_args]]
    apply(mod, fun, arg) |> Enum.map(&unstruct/1)
  end

  def run_convert(changeset, cmd_args) do
    case clst = cmd_args[:op_convert] do
      [] -> changeset
      _ -> perform_convert(changeset, cmd_args)
    end
  end

  def run_apply(changeset, _cmd_args) do
    changeset
  end

  defp unstruct(struct) do
    struct
    |> Map.from_struct()
  end

  defp perform_convert(changeset, cmd_args) when is_list(cmd_args) do
    cmd_args
    |> Enum.reduce(changeset, fn(el, acc) -> xconvert(el, acc) end)
  end

  # defp xconvert(el, changeset) do


  defp convert_method(type) do

  end



end
