defmodule RfxCli.Main.ExtractCommandTest do
  use ExUnit.Case

  alias RfxCli.Main.Parse
  alias RfxCli.Main.ExtractCommand

  describe "command option" do
    test "flag: -s" do
      result =
        Parse.run("-s")
        |> ExtractCommand.run()

      assert result
      refute result[:launch_repl]
      assert result[:launch_server]
    end

    test "flag: -r" do
      result =
        Parse.run("-r")
        |> ExtractCommand.run()

      assert result
      assert result[:launch_repl]
      refute result[:launch_server]
    end
  end

  describe "subcommand options" do
    test "no_op" do
      result =
        Parse.run("proto.no_op tgt")
        |> ExtractCommand.run()

      assert result 
    end
  end
end
