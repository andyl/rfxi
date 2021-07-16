defmodule RfxCli.Main.GenOptimusTest do
  use ExUnit.Case

  alias RfxCli.Main.GenOptimus

  describe "OptimusBasics" do
    test "basic execution" do
      conf = [author: "asdf", about: "qwer", description: "zxcv", version: "0.1"]
      result = conf |> Optimus.new!()
      assert result
    end
  end

  describe "#run" do
    test "help" do
      result = GenOptimus.run("--help")

      assert result 
      assert result.optimus_data 
      assert result.optimus_data.about
      assert result.optimus_data.subcommands
      assert result.optimus_data.options
      assert result.optimus_data.flags
    end

    test "help proto.no_op" do
      result = GenOptimus.run("proto.no_op")
      assert result
      assert result.optimus_data 
      assert result.optimus_data.about
      assert result.optimus_data.subcommands
      assert result.optimus_data.options
      assert result.optimus_data.flags
    end
  end

  describe "#run with valid cmd" do
    test "cmd: Repl" do
      result = GenOptimus.run("Repl")
      assert result
      assert result.optimus_data 
      assert result.optimus_data.about
      assert result.optimus_data.subcommands
      assert result.optimus_data.options
      assert result.optimus_data.flags
    end

    test "cmd: Server" do
      result = GenOptimus.run("Server")
      assert result
    end

    test "subcommand" do
      result = GenOptimus.run("proto.no_op target")
      assert result
    end
  end
end
