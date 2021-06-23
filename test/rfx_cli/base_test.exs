defmodule RfxCli.BaseTest do
  use ExUnit.Case

  alias RfxCli.Base
  import ExUnit.CaptureIO

  describe "#optimus_spec" do
    test "generates output" do
      assert Base.optimus_spec() 
    end
  end

  describe "#optimus_parse" do
    test "help" do
      fun = fn -> Base.optimus_parse("--help") end
      assert capture_io(fun) =~ "rfx"
    end

    test "help proto.no_op" do
      fun = fn -> Base.optimus_parse("help proto.no_op") end
      assert capture_io(fun) =~ "proto.no_op"
    end
  end

end
