defmodule RfxCli.Util.InferScope do
  def for(path) do
    IO.inspect path
    zpath = path || ""
    xpath = zpath |> Path.expand()
    cond do
      is_tmpfile?(xpath) -> "cl_tmpfile"
      is_subapp_dir?(xpath) -> "cl_subapp"
      is_proj_dir?(xpath) -> "cl_project"
      is_file?(xpath) -> "cl_file"
      true -> "cl_code"
    end
  end

  defp is_tmpfile?(path) do
    Regex.match?(~r/\/tmp\//, path) && File.exists?(path) && ! File.dir?(path)
  end

  defp is_proj_dir?(path) do
    File.dir?(path) &&
      File.exists?(path <> "/mix.exs") &&
        ! Regex.match?(~r/\/apps\//, path)
  end

  defp is_file?(path) do
    File.exists?(path) && ! File.dir?(path)
  end

  defp is_subapp_dir?(path) do
    File.dir?(path) &&
      File.exists?(path <> "/mix.exs") &&
        Regex.match?(~r/\/apps\//, path)
  end
end
