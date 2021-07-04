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
    test "cmd: RfxRepl" do
      result = Parse.run("RfxRepl")
      assert result  
    end

    test "cmd: CredoRepl" do
      result = Parse.run("CredoRepl")
      assert result  
    end

    test "cmd: Server" do
      result = Parse.run("Server")
      assert result 
    end

    test "subcommand" do
      result = Parse.run("proto.no_op target")
      assert result 
    end
  end

end
