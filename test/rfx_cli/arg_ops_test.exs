defmodule RfxCli.ArgOpsTest do
  use ExUnit.Case

  describe "#subcommands" do
    test "output" do
      result  = RfxCli.ArgOps.subcommands()
      assert result
    end
  end
  
end
