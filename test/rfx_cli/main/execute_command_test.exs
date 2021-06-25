defmodule RfxCli.Main.ExecuteCommandTest do
  use ExUnit.Case

  alias RfxCli.Main.Parse
  alias RfxCli.Main.ExtractCommand
  alias RfxCli.Main.ExecuteCommand

  describe "subcommand options" do
    test "no_op" do
      result =
        Parse.run("proto.no_op tgt")
        |> ExtractCommand.run()
        |> ExecuteCommand.run_subcmd()

      assert result  
      assert result == []
    end

    test "comment_add" do
      [result | _] =
        Parse.run("proto.comment_add :ok")
        |> ExtractCommand.run()
        |> ExecuteCommand.run_subcmd()

      assert result  
      assert result.text_req
    end
  end
end
