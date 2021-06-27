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
    |> main_core()
    |> encode_changelist()
  end

  def main_core(argv) do
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
    case Main.ExecuteCommand.run(cmd_args) do
      val = {:error, _, _} -> val
      val -> val
    end
  end

  def encode_changelist({:error, _, _}) do
  end

  def encode_changelist(changelist) do
    changelist
    |> Enum.map(&unstruct/1)
    |> Jason.encode!()
    |> Jason.Formatter.pretty_print()
    |> IO.puts()
  end

  defp unstruct(struct) do
    struct
    |> Map.from_struct()
  end


end
