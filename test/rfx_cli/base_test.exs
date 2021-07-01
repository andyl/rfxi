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
      new_state =
        "proto.no_op target"
        |> Base.parse()
        |> Base.extract_command()

      result = new_state.cmd_args

      assert result
      assert result[:op_module] == Rfx.Ops.Proto.NoOp
      assert result[:op_scope] == :cl_code
    end
  end

  describe "#execute_command" do
    test "proto.no_op" do
      new_state =
        "proto.no_op target"
        |> Base.parse()
        |> Base.extract_command()
        |> Base.execute_command()

      result = new_state.changeset

      assert result == []
    end

    test "proto.comment_add" do
      new_state = 
        "proto.comment_add target"
        |> Base.parse()
        |> Base.extract_command()
        |> Base.execute_command()

      [result | _] = new_state.changeset

      assert result 
      assert Map.fetch!(result, :text_req)
      refute Map.fetch!(result, :file_req)
      refute Map.fetch!(result, :log)
    end

    test "proto.comment_add with quoted target" do
      new_state = 
        ~S(proto.comment_add "x = 1" -c to_upcase)
        |> Base.parse()
        |> Base.extract_command()
        |> Base.execute_command()

      [result | _] = new_state.changeset

      assert result 
      assert Map.fetch!(result, :text_req)
      refute Map.fetch!(result, :file_req)
      assert Map.fetch!(result, :log)
    end

    test "proto.comment_add with convert" do
      new_state = 
        "proto.comment_add target -c to_string"
        |> Base.parse()
        |> Base.extract_command()
        |> Base.execute_command()

      [result | _] = new_state.changeset

      assert result 
      assert Map.fetch!(result, :text_req)
      refute Map.fetch!(result, :file_req)
      assert Map.fetch!(result, :log)
    end

    test "proto.comment_add with apply" do
      new_state =
        "proto.comment_add target -a"
        |> Base.parse()
        |> Base.extract_command()
        |> Base.execute_command()

      [ result | _ ] = new_state.changeset

      assert result 
      assert Map.fetch!(result, :text_req)
      refute Map.fetch!(result, :file_req)
      assert Map.fetch!(result, :log)
    end

  end

  describe "#main_core converters" do

    test "proto.comment_add" do
      new_state = 
        "proto.comment_add target -c to_string"
        |> Base.main_core()

      [result | _] = new_state.changeset

      assert result  
      assert Map.fetch!(result, :text_req)
      refute Map.fetch!(result, :file_req)
      assert Map.fetch!(result, :log)
    end

    test "proto.comment_add dual-conversion" do
      new_state = 
        "proto.comment_add target -c to_string,to_upcase"
        |> Base.main_core()

      [result | _] = new_state.changeset

      assert result  
      assert Map.fetch!(result, :text_req)
      refute Map.fetch!(result, :file_req)
      assert Map.fetch!(result, :log)
    end

  end

  describe "#main" do

    test "proto.no_op" do
      fun = fn -> Base.main("proto.no_op target") end
      assert capture_io(fun) == "[]\n"
    end

    test "proto.comment_add" do
      fun = fn -> Base.main("proto.comment_add target") end
      assert capture_io(fun) =~ "target"
    end

  end
end
