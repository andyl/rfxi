defmodule RfxCli.Main.ValidateCommand do
  @moduledoc false

  def run({:error, stage, msg}) do
    {:error, stage, msg}
  end

  def run(cmd_args) do
    cmd_args
  end
end
