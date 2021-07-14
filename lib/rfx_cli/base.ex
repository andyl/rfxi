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

  def main(argv) when is_binary(argv) do
    argv
    |> OptionParser.split()
    |> main()
  end

  def main(argv) do
    %{argv: argv}
    |> main_core()
    |> print_output()
  end

  def main(argv, initial_state) when is_map(initial_state) do 
    initial_state
    |> IO.inspect(label: "ASDFASDF") 
    |> Map.merge(%{argv: argv})
    |> main_core()
    |> print_output()
  end

  def main_core(argv) when is_binary(argv) do
    argv
    |> OptionParser.split()
    |> main_core()
  end

  def main_core(argv) when is_list(argv) do
    %{argv: argv}
    |> main_core()
  end

  def main_core(initial_state) do
    initial_state
    |> new_state()
    |> parse()
    |> validate_parse()
    |> extract_command()
    |> validate_command()
    |> execute_command()
    |> encode_changeset()
  end

  def parse({:error, msg}), do: {:error, msg}

  def parse(input) when is_binary(input) do
    argv = input |> OptionParser.split()
    %{argv: argv}
    |> new_state()
    |> parse()
  end

  def parse(state) do
    case Main.Parse.run(state) do
      {:error, msg} -> {:error, msg}
      result -> assign(state, :parse, result)
    end
  end

  def validate_parse(state) do
    state
  end

  def extract_command({:error, msg}), do: {:error, msg}

  def extract_command(state) do
    case Main.ExtractCommand.run(state.parse) do
      {:error, msg} -> {:error, msg}
      result -> assign(state, :cmd_args, result)
    end
  end

  def validate_command(state) do
    state
  end

  def execute_command({:error, msg}), do: {:error, msg}

  def execute_command(state) do
    case Main.ExecuteCommand.run(state.cmd_args) do
      {:error, msg} -> {:error, msg}
      result -> assign(state, :changeset, result)
    end
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

    assign(state, :json, json)
  end

  def print_output({:error, msg}), do: {:error, msg}

  def print_output(state) do
    case state.cmd_args[:op_oneline] do
      true -> state.json |> IO.puts()
      false -> state.json |> Jason.Formatter.pretty_print() |> IO.puts()
    end
  end

  defp unstruct(struct) do
    struct
    |> Map.from_struct()
  end

  defp new_state(initial_state) do
    initial_state
    |> RfxCli.State.new()
  end

  def assign(state, field, value) do
    Map.merge(state, %{field => value})
  end
end
