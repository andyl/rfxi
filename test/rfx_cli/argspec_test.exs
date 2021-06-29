defmodule RfxCli.ArgspecTest do
  use ExUnit.Case

  describe "#optimus_spec" do
    test "generates output" do
      assert RfxCli.Argspec.gen()
    end
  end

end
