defmodule RfxCli.Main do
  
  # READING FROM STDIO
  # defp get_stdin do
  #   case IO.read(:stdio, :line) do
  #     :eof -> ""
  #     {:error, _} -> ""
  #     data -> data
  #   end
  # end

  @moduledoc """
  Main CLI module.
  """

  alias RfxCli.Main
  alias RfxCli.State
  alias RfxCli.Main

  def main(argv), do: run(argv)
  def main(argv, state), do: run(argv, state)

  def run(argv) when is_binary(argv) do
    argv
    |> OptionParser.split()
    |> run()
  end

  def run(argv) do
    %{argv: argv}
    |> run_core()
    |> print_output()
  end

  def run(argv, initial_state) when is_map(initial_state) do 
    initial_state
    |> Map.merge(%{argv: argv})
    |> run_core()
    |> print_output()
  end

  def run_core(argv) when is_binary(argv) do
    argv
    |> OptionParser.split()
    |> run_core()
  end

  def run_core(argv) when is_list(argv) do
    %{argv: argv}
    |> run_core()
  end

  def run_core(initial_state) do
    initial_state
    |> new_state()
    |> gen_optimus()
    |> parse_argv()
    |> validate_parse()
    |> extract_command()
    |> validate_command()
    |> execute_command()
    |> encode_changeset()
  end

  def new_state(initial_state) do
    initial_state
    |> State.new()
  end

  def gen_optimus(state) do 
    state
    |> Main.GenOptimus.run()
  end

  def parse_argv({:error, msg}), do: {:error, msg}

  def parse_argv(input) when is_binary(input) do
    argv = input |> OptionParser.split()
    %{argv: argv}
    |> new_state()
    |> gen_optimus()
    |> parse_argv()
  end

  def parse_argv(state) do
    state
    |> Main.ParseArgv.run()
  end

  def validate_parse(state) do
    state
  end

  def extract_command({:error, msg}), do: {:error, msg}

  def extract_command(state) do
    state
    |> Main.ExtractCommand.run()
  end

  def validate_command(state) do
    state
  end

  def execute_command({:error, msg}), do: {:error, msg}

  def execute_command(state) do
    state 
    |> Main.ExecuteCommand.run()
  end

  def encode_changeset({:error, msg}), do: {:error, msg}

  def encode_changeset(%{changeset: :ok}) do 
    {:error, "Closed"}
  end 

  def encode_changeset(state) do
    json =
      state.changeset
      |> Enum.map(&unstruct/1)
      |> Jason.encode!()

    State.assign(state, :json, json)
  end

  def print_output({:error, msg}), do: {:error, msg}

  def print_output(state) do
    case state.command_args[:op_oneline] do
      true -> state.json |> IO.puts()
      false -> state.json |> Jason.Formatter.pretty_print() |> IO.puts()
    end
  end

  defp unstruct(struct) do
    struct
    |> Map.from_struct()
  end

end
