defmodule RfxCli.Main.ParseArgvTest do
  use ExUnit.Case

  alias RfxCli.Main.ParseArgv
  import ExUnit.CaptureIO

  describe "OptimusBasics" do
    test "basic execution" do
      conf = [ author: "asdf", about: "qwer", description: "zxcv", version: "0.1" ]
      argv = ["--help"]
      func = fn -> Optimus.new!(conf) |> Optimus.parse(argv) end
      result = capture_io(func)
      assert result 
    end
  end

  describe "#run" do
    test "help" do
      fun = fn -> ParseArgv.run("--help") end
      result = capture_io(fun) 
      # IO.puts(result)
      assert result =~ "rfx"
    end

    test "help proto.no_op" do
      fun = fn -> ParseArgv.run("help proto.no_op") end
      assert capture_io(fun) =~ "proto.no_op"
    end
  end

  describe "#run with valid cmd" do
    test "cmd: Repl" do
      result = ParseArgv.run("Repl")
      assert result  
    end

    test "cmd: Server" do
      result = ParseArgv.run("Server")
      assert result 
    end

    test "subcommand" do
      result = ParseArgv.run("proto.no_op target")
      assert result 
    end
  end

end
