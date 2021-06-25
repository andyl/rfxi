defmodule RfxCli.Base do
  # READING FROM STDIO
  # defp get_stdin do
  #   case IO.read(:stdio, :line) do
  #     :eof -> ""
  #     {:error, _} -> ""
  #     data -> data
  #   end
  # end

  def main(argv) do
    argv
    |> parse()
    |> validate_parse()
    |> extract_command()
    |> validate_command()
    |> execute_command()
  end

  def parse(argv) when is_binary(argv) do
    String.split(argv, " ")
    |> parse()
  end

  def parse(argv) do
    haltfun = fn _ -> :halt end
    argspec = RfxCli.Argspec.gen()
    optimus = argspec |> Optimus.parse!(argv, haltfun)

    case optimus do
      {:ok, result} -> result
      alt -> alt
    end
  end

  def validate_parse(result) do
    result
  end

  def extract_command(_parse) do
    _command = []
  end

  def validate_command(command) do
    command
  end

  def execute_command(command) do
    command
  end

  def execute({:error, alt}) do
    IO.puts("ERROR!")
    IO.inspect(alt)
  end

  def execute(%{flags: %{repl: true}}) do
    RfxCli.Repl.start()
  end

  def execute(%{flags: %{server: true}}) do
    RfxCli.Server.start()
  end

  def execute({[op_atom], parse_data}) do
    run_command(op_atom, parse_data)
  end

  def execute(optimus) do
    IO.inspect(optimus)
  end

  def run_command(subcommand, parse_data) do
    case validate(subcommand, parse_data) do
      :ok -> perform(subcommand, parse_data)
      {:error, _message} -> IO.puts("Validation ERROR!")
      _ -> IO.puts("Error No Validation match")
    end
  end

  def validate(_subcommand, _parse_data) do
    :ok
  end

  def perform(subcommand, parse_data) do
    IO.inspect(parse_data)
    sub = subcommand |> Atom.to_string() |> String.replace("_", ".")
    mod = ("Elixir.Rfx.Ops." <> sub) |> String.to_atom()
    fun = set_scope(parse_data) |> String.to_atom()
    tgt = Map.fetch!(parse_data, :args)[:target] || ""
    opt = opts_for(parse_data) |> IO.inspect()
    arg = [tgt, opt]
    IO.inspect(opt)
    # |> IO.puts()
    apply(mod, fun, arg) |> Enum.map(&unstruct/1) |> Jason.encode!()
  end

  def unstruct(struct) do
    struct
    |> Map.from_struct()
  end

  defp opts_for(parse_data) do
    parse_data
    |> Map.fetch!(:options)
    |> Map.delete(:changelist)
    |> Map.delete(:scope)
    |> Keyword.new()
  end

  defp set_scope(parse_data) do
    scope = Map.fetch!(parse_data, :options)[:scope]
    target = Map.fetch!(parse_data, :args)[:target]

    case scope do
      nil -> RfxCli.Util.InferScope.for(target)
      "code" -> "cl_code"
      "file" -> "cl_file"
      "project" -> "cl_project"
      "subapp" -> "cl_subapp"
      "tmpfile" -> "cl_tmpfile"
      _ -> raise("Error: unknown scope (#{scope})")
    end
  end
end
