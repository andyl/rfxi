defmodule RfxCli.ArgSpecTest do
  use ExUnit.Case

  describe "#base_config" do
    test "generates output" do
      assert RfxCli.ArgSpec.base_config()
    end
  end

  describe "#base_subcommands" do
    test "generates output" do
      assert RfxCli.ArgSpec.base_subcommands()
    end
  end

  describe "#operation_config" do
    test "generates output" do
      assert RfxCli.ArgSpec.operation_config()
    end
  end

end
