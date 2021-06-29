defmodule RfxCli.Main.ParseTest do
  use ExUnit.Case

  alias RfxCli.Main.Parse
  import ExUnit.CaptureIO

  describe "#run" do
    test "help" do
      fun = fn -> Parse.run("--help") end
      assert capture_io(fun) =~ "rfx"
    end

    test "help proto.no_op" do
      fun = fn -> Parse.run("help proto.no_op") end
      assert capture_io(fun) =~ "proto.no_op"
    end
  end

  describe "#run with valid cmd" do
    test "flag: -s" do
      result = Parse.run("-s")
      assert result  
    end

    test "flag: -r" do
      result = Parse.run("-r")
      assert result 
    end

    test "subcommand" do
      result = Parse.run("proto.no_op target")
      assert result 
    end
  end

end
