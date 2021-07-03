defmodule RfxCli.Util.Io do

  @moduledoc """
  Runs a function while discarding STDIO.
  """

  def run_silently(fun) do
    original_gl = Process.group_leader()
    {:ok, capture_gl} = StringIO.open("")
    try do
      Process.group_leader(self(), capture_gl)
      do_capture(capture_gl, fun)
    after
      Process.group_leader(self(), original_gl)
    end
  end

  defp do_capture(string_io, fun) do 
    try do
      fun.()
    catch
      kind, reason -> 
        _ = StringIO.close(string_io)
        :erlang.raise(kind, reason, __STACKTRACE__)
    else
      result ->
        {:ok, {_input, _output}} = StringIO.close(string_io)
        result
    end
  end

end
