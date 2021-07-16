defmodule RfxCli.Main.ExecuteCommandTest do
  use ExUnit.Case

  alias RfxCli.Main.ParseArgv
  alias RfxCli.Main.ExtractCommand
  alias RfxCli.Main.ExecuteCommand

  import ExUnit.CaptureIO

  describe "command option" do
    test "cmd: Server" do
      state =
        ParseArgv.test_run("Server")
        |> ExtractCommand.run()

      fun = fn -> ExecuteCommand.run(state) end

      assert capture_io(fun) =~ "STARTING SERVER"
    end

    test "cmd: Repl" do
      cmd_args =
        ParseArgv.test_run("Repl")
        |> ExtractCommand.run()

      fun = fn -> ExecuteCommand.run(cmd_args) end

      assert capture_io(fun) =~ "STARTING REPL"
    end
  end

  describe "subcommand options" do
    test "no_op" do
      state =
        ParseArgv.test_run("proto.no_op tgt")
        |> ExtractCommand.run()
        |> ExecuteCommand.run()

      assert state 
      assert state.changeset 
      assert state.changeset == []
    end

    test "comment_add" do
      state =
        ParseArgv.test_run("proto.comment_add :ok")
        |> ExtractCommand.run()
        |> ExecuteCommand.run()

      [changeset | _] = state.changeset
      assert changeset 
      assert changeset
      assert changeset.text_req
    end
  end
end
