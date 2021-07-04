defmodule RfxCli.CredoRepl do

  @moduledoc """
  Credo REPL

  Commands:
    - help                   - display a help message
    - suggest                - run and display a credo analysis
    - detail <CredoIssueId>  - show the detail for a credo issue
    - apply <RfxOperationId> - apply an operation to the filesystem
    - exit                   - quit the repl
  """

  def start do
    loop("begin", %{count: 1})
  end

  def start(state) do 
    loop("begin", state)
  end

  def loop("begin", state) do
    IO.puts("STARTING CREDO REPL")

    if Application.get_env(:rfxi, :env) != :test do
      loop(:ok, state)
    end
  end

  def loop(_, state) do
    command = get_input(state)

    case run(command, state) do
      :halt -> IO.puts("DONE")
      new_state -> loop("continue", %{new_state | count: state.count + 1})
    end
  end

  defp get_input(state) do
    IO.gets("rfx_credo_repl_#{state.count}> ")
    |> String.trim() |> String.split(" ")
  end

  defp run([""], state) do
    state
  end

  defp run(["help"], state) do 
    state
  end

  defp run(["detail", _issue_id], state) do 
    state
  end

  defp run(["apply", _operation_id], state) do 
    state
  end

  defp run(["suggest"], state) do 
    results = RfxCli.Util.Credo.run()
    %{ state | credo_results: results }
  end

  defp run(["exit"], _state) do
    :halt
  end

  # defp run(command, state) do
  #   RfxCli.Base.main(command)
  # end
end
