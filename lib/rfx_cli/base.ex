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
    |> optimus_parse()
    |> execute()
  end

  def optimus_parse(argv_string) when is_binary(argv_string) do
    argv_string
    |> String.split(" ")
    |> optimus_parse()
  end

  def optimus_parse(argv) do 
    haltfun = fn(_) -> :halt end
    case optimus_spec() |> Optimus.parse!(argv, haltfun) do
      {:ok, result} -> result
      alt -> alt
    end
  end

  def optimus_spec do
    Optimus.new!(
      name: "rfx",
      description: "Refactoring operations for Elixir",
      version: "0.0.1",
      about: "Refactoring operations for Elixir Code.",
      allow_unknown_args: false,
      flags: [
        repl: [
          short: "-r",
          long: "--repl", 
          help: "Run in REPL mode"
        ],
        server: [
          short: "-s",
          long: "--server", 
          help: "Run web server"
        ]
      ],
      subcommands: RfxCli.Oplst.subcommands()
    )
  end

  def execute(:halt) do
  end

  def execute({:error, alt}) do
    IO.puts "ERROR!"
    IO.inspect alt
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
    IO.puts "RUN_COMMAND"
    IO.inspect(subcommand)
    IO.inspect(parse_data)
    case validate(subcommand, parse_data) do
      :ok -> perform(subcommand, parse_data)
      {:error, _message} -> IO.puts "Validation ERROR!"
      _ -> IO.puts "Error No Validation match"
    end
  end

  def validate(_subcommand, _parse_data) do
    :ok
  end

  def perform(subcommand, parse_data) do
    IO.puts "PERFORM_COMMAND"
    IO.inspect(subcommand |> Atom.to_string())
    IO.inspect(parse_data)
    sub = subcommand |> Atom.to_string() |> String.replace("_", ".")
    mod = "Elixir.Rfx.Ops." <> sub |> String.to_atom()
    fun = "cl_code" |> String.to_atom()
    arg = [":ok"]
    IO.inspect mod
    IO.inspect fun
    IO.inspect arg
    apply(mod, fun, arg) |> IO.inspect()
  end

end
