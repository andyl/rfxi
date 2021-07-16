defmodule RfxCli.Main.ExtractCommandTest do
  use ExUnit.Case

  alias RfxCli.Main.ParseArgv
  alias RfxCli.Main.ExtractCommand

  describe "command option" do
    test "cmd: Server" do
      result =
        ParseArgv.run("Server")
        |> ExtractCommand.run()

      assert result 
      assert result[:command_args]
      assert result[:command_args][:launch_cmd] == :server
      assert result[:command_args][:launch_args]
    end

    test "cmd: Repl" do
      result =
        ParseArgv.run("Repl")
        |> ExtractCommand.run()

      assert result
      assert result[:command_args]
      assert result[:command_args][:launch_cmd] == :repl
      assert result[:command_args][:launch_args]
    end
  end

  describe "subcommand options" do
    test "no_op" do
      result =
        ParseArgv.run("proto.no_op tgt")
        |> ExtractCommand.run()

      assert result
      assert result[:command_args]
      assert result[:command_args][:op_module] == Rfx.Ops.Proto.NoOp
    end
  end
end
