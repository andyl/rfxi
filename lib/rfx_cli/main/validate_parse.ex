defmodule RfxCli.Main.ValidateParse do
  @moduledoc false

  def run({:error, stage, msg}) do
    {:error, stage, msg}
  end

  def run(parse_data) do
    parse_data
  end

end
