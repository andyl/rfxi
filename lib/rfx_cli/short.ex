defmodule Short do
  @moduledoc false

  def noop do
    RfxCli.Oplst.proto_ops() |> Enum.reverse() |> List.first()
  end

  def argspec do
    noop()
    |> Rfx.Util.OpInfo.argspec()
  end

  def oblock do
    noop()
    |> RfxCli.Oplst.option_block()
  end

  def mo do
    noop()
    |> RfxCli.Oplst.merged_options()
  end

end
