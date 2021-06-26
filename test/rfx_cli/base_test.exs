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

  describe "#extract_command" do
    test "proto.no_op" do
      result =
        "proto.no_op target"
        |> Base.parse()
        |> Base.extract_command()

      assert result
      assert result[:op_module] == Rfx.Ops.Proto.NoOp
      assert result[:op_scope] == :cl_code
    end
  end

  describe "#execute_command" do
    test "proto.no_op" do
      result =
        "proto.no_op target"
        |> Base.parse()
        |> Base.extract_command()
        |> Base.execute_command()

      assert result == []
    end

    test "proto.comment_add" do
      [result | _] =
        "proto.comment_add target"
        |> Base.parse()
        |> Base.extract_command()
        |> Base.execute_command()

      assert result
      assert result[:text_req]
      refute result[:file_req]
      refute result[:log]
    end
  end

  describe "#main_core" do
    test "proto.comment_add" do
      [result | _] =
        "proto.comment_add target -c to_string"
        |> Base.main_core()

      assert result |> IO.inspect()
      # assert result[:text_req]
      # refute result[:file_req]
      # assert result[:log]
    end
  end

  describe "#main" do
    test "proto.no_op" do
      result =
        "proto.no_op target"
        |> Base.main()

      assert result
      assert result == "[]"
    end

    test "proto.comment_add" do
      result =
        "proto.comment_add target"
        |> Base.main()

      assert result 
    end
  end
end
