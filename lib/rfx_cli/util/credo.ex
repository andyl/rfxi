defmodule RfxCli.Util.Credo do

  @moduledoc """
  Runs credo as a library, rather than a CLI.

  Runs over the current directory and returns a list of Credo issues.
  """
  def run do 
    # suppress output
    GenServer.call(Elixir.Credo.CLI.Output.Shell, {:supress_output, true})
    []
    |> Credo.Execution.build()
    |> Credo.Execution.run()
    |> Credo.Execution.ExecutionIssues.to_map()
    |> merge_rfx_operations()
  end

  defp merge_rfx_operations(issues)  when is_map(issues) do 
    issues
    |> Enum.map(fn({key, val}) -> {key, process_issues(val)} end)
    |> Enum.into(%{})
  end

  defp process_issues(issues) when is_list(issues) do 
    issues
    |> Enum.map(&(attach_rfx_operations(&1)))
  end

  # If there are associated Rfx Operations (defined in the Operation's
  # propspec), they are stored in the `meta` field of the Credo issue.
  defp attach_rfx_operations(issue) do 
    operations = Rfx.Catalog.OpsCat.find_by_prop(:credo_check, Map.fetch!(issue, :check))

    %{issue | meta: operations}
  end

end
