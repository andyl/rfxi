defmodule RfxCli.Util.IoTest do
  use ExUnit.Case

  alias RfxCli.Util.Io

  defmodule LclTst do
    def myfun do
      myfun("default_text")
    end

    def myfun(text) do
      IO.puts(text)
      String.upcase(text)
    end
  end

  describe "#run_silently/0" do

    test "function reference" do
      assert Io.run_silently(&LclTst.myfun/0) == "DEFAULT_TEXT"
    end

    test "anonymous function" do
      assert Io.run_silently(fn -> LclTst.myfun("input_text") end) == "INPUT_TEXT"
    end

  end

end
