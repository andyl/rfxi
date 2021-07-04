defmodule RfxCli.Util.CredoTest do
  use ExUnit.Case

  describe "#run" do
    test "basic execution" do
      result = RfxCli.Util.Credo.run()
      assert result 
    end
  end
  
end
