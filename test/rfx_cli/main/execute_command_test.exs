defmodule RfxCli.Main.ExecuteCommandTest do
  use ExUnit.Case

  alias RfxCli.Main.Parse
  alias RfxCli.Main.ExtractCommand
  alias RfxCli.Main.ExecuteCommand

  import ExUnit.CaptureIO

  describe "command option" do
    test "cmd: Server" do
      cmd_args =
        Parse.run("Server")
        |> ExtractCommand.run()

      fun = fn -> ExecuteCommand.run(cmd_args) end

      assert capture_io(fun) =~ "STARTING SERVER"
    end

    test "cmd: RfxRepl" do
      cmd_args =
        Parse.run("RfxRepl")
        |> ExtractCommand.run()

      fun = fn -> ExecuteCommand.run(cmd_args) end

      assert capture_io(fun) =~ "STARTING RFX REPL"
    end
  end

  describe "subcommand options" do
    test "no_op" do
      result =
        Parse.run("proto.no_op tgt")
        |> ExtractCommand.run()
        |> ExecuteCommand.run()

      assert result  
      assert result == []
    end

    test "comment_add" do
      [result | _] =
        Parse.run("proto.comment_add :ok")
        |> ExtractCommand.run()
        |> ExecuteCommand.run()

      assert result 
      assert result.text_req
    end
  end
end