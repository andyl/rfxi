defmodule RfxCli.BaseTest do
  use ExUnit.Case

  alias RfxCli.Base
  import ExUnit.CaptureIO

  describe "#parse" do
    test "help" do
      fun = fn -> Base.parse("--help") end
      assert capture_io(fun) =~ "rfx"
    end

    test "help proto.no_op" do
      fun = fn -> Base.parse("help proto.no_op") end
      assert capture_io(fun) =~ "proto.no_op"
    end
  end

end
