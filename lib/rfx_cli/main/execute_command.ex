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

  def run_convert(changeset, _cmd_args) do
    changeset
  end

  def run_apply(changeset, _cmd_args) do
    changeset
  end

  def unstruct(struct) do
    struct
    |> Map.from_struct()
  end

end
