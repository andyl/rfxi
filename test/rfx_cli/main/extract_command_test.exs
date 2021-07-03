defmodule RfxCli.Main.ExtractCommandTest do
  use ExUnit.Case

  alias RfxCli.Main.Parse
  alias RfxCli.Main.ExtractCommand

  describe "command option" do
    test "cmd: Server" do
      result =
        Parse.run("Server")
        |> ExtractCommand.run()

      assert result 
      assert result[:launch_cmd] == :server
      assert result[:launch_args]
    end


    test "cmd: Repl" do
      result =
        Parse.run("Repl")
        |> ExtractCommand.run()

      assert result
      assert result[:launch_cmd] == :repl
      assert result[:launch_args]
    end
  end

  describe "subcommand options" do
    test "no_op" do
      result =
        Parse.run("proto.no_op tgt")
        |> ExtractCommand.run()

      assert result 
      assert result[:op_module] == Rfx.Ops.Proto.NoOp
    end
  end
end
