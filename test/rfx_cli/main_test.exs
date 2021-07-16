defmodule RfxCli.MainTest do
  use ExUnit.Case

  alias RfxCli.Main
  import ExUnit.CaptureIO
  
  describe "#parse_argv" do
    test "help" do
      fun = fn -> Main.parse_argv("--help") end
      assert capture_io(fun) =~ "rfx"
    end

    test "help proto.no_op" do
      fun = fn -> Main.parse_argv("help proto.no_op") end
      assert capture_io(fun) =~ "proto.no_op"
    end
  end

  describe "#extract_command" do
    test "proto.no_op" do
      state =
        "proto.no_op target"
        |> Main.parse_argv()
        |> Main.extract_command()

      command_args = state.command_args

      assert command_args
      assert command_args[:op_module] == Rfx.Ops.Proto.NoOp
      assert command_args[:op_scope] == :cl_code
    end
  end

  describe "#execute_command" do
    test "proto.no_op" do
      state =
        "proto.no_op target"
        |> Main.parse_argv()
        |> Main.extract_command()
        |> Main.execute_command()

      changeset = state.changeset

      assert changeset == []
    end

    test "proto.comment_add" do
      state = 
        "proto.comment_add target"
        |> Main.parse_argv()
        |> Main.extract_command()
        |> Main.execute_command()

      [changereq | _] = state.changeset

      assert changereq 
      assert Map.fetch!(changereq, :text_req)
      refute Map.fetch!(changereq, :file_req)
      refute Map.fetch!(changereq, :log)
    end

    test "proto.comment_add with quoted target" do
      state = 
        ~S(proto.comment_add "x = 1" -c to_upcase)
        |> Main.parse_argv()
        |> Main.extract_command()
        |> Main.execute_command()

      [changereq | _] = state.changeset

      assert changereq 
      assert Map.fetch!(changereq, :text_req)
      refute Map.fetch!(changereq, :file_req)
      assert Map.fetch!(changereq, :log)
    end

    test "proto.comment_add with convert" do
      state = 
        "proto.comment_add target -c to_string"
        |> Main.parse_argv()
        |> Main.extract_command()
        |> Main.execute_command()

      [changereq | _] = state.changeset

      assert changereq 
      assert Map.fetch!(changereq, :text_req)
      refute Map.fetch!(changereq, :file_req)
      assert Map.fetch!(changereq, :log)
    end

    test "proto.comment_add with apply" do
      state =
        "proto.comment_add target -a"
        |> Main.parse_argv()
        |> Main.extract_command()
        |> Main.execute_command()

      [ changereq | _ ] = state.changeset

      assert changereq 
      assert Map.fetch!(changereq, :text_req)
      refute Map.fetch!(changereq, :file_req)
      assert Map.fetch!(changereq, :log)
    end

  end

  describe "#main_core converters" do

    test "proto.comment_add" do
      state = 
        "proto.comment_add target -c to_string"
        |> Main.run_core()

      [changereq | _] = state.changeset

      assert changereq  
      assert Map.fetch!(changereq, :text_req)
      refute Map.fetch!(changereq, :file_req)
      assert Map.fetch!(changereq, :log)
    end

    test "proto.comment_add dual-conversion" do
      state = 
        "proto.comment_add target -c to_string,to_upcase"
        |> Main.run_core()

      [changereq | _] = state.changeset

      assert changereq  
      assert Map.fetch!(changereq, :text_req)
      refute Map.fetch!(changereq, :file_req)
      assert Map.fetch!(changereq, :log)
    end

  end

  describe "#main" do

    test "proto.no_op" do
      fun = fn -> Main.run("proto.no_op target") end
      assert capture_io(fun) == "[]\n"
    end

    test "proto.comment_add" do
      fun = fn -> Main.run("proto.comment_add target") end
      assert capture_io(fun) =~ "target"
    end

  end
end
