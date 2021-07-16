defmodule RfxCli.ArgTest do
  use ExUnit.Case

  alias RfxCli.Arg
  alias RfxCli.State

  describe "#gen_token" do
    test "generates output" do
      assert Arg.gen_token(:ok)
    end
  end

  describe "#build" do
    test "basic output" do
      result = %{argv: "--help"} |> State.new() |> Arg.build()
      assert result 
      assert result[:name]
      assert result[:flags]
      assert result[:version]
      assert result[:description]
      assert result[:subcommands]
    end
  end

end
