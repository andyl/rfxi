defmodule RfxCli.Base do
  # READING FROM STDIO
  # defp get_stdin do
  #   case IO.read(:stdio, :line) do
  #     :eof -> ""
  #     {:error, _} -> ""
  #     data -> data
  #   end
  # end

  alias RfxCli.Main

  def main(argv) do
    argv
    |> parse()
    |> validate_parse()
    |> extract_command()
    |> validate_command()
    |> execute_command()
  end

  def parse(argv) do
    Main.Parse.run(argv)
  end

  def validate_parse(parse_data) do
    Main.ValidateParse.run(parse_data)
  end

  def extract_command(parse_data) do
    Main.ExtractCommand.run(parse_data)
  end

  def validate_command(cmd_args) do
    Main.ValidateCommand.run(cmd_args)
  end

  def execute_command(cmd_args) do
    Main.ExecuteCommand.run(cmd_args) 
  end

end
