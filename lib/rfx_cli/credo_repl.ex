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
    IO.puts("STARTING CREDO REPL - type '?' for help...")

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
    IO.gets("rfx_credo_repl_#{state.count}> ") |> String.trim() |> String.split(" ")
  end

  defp run([""], state) do
    state
  end

  defp run(["?"], state) do
    run(["help"], state)
  end

  defp run(["help"], state) do
    opts = """

      Commands:
      - help           - display this help message
      - suggest        - run and display a Credo analysis
      - detail <ID>    - show the detail for a Credo Issue
      - apply <Rfx Id> - apply an Rfx Operation to the filesystem
      - exit           - quit the repl
    """

    IO.puts(opts)

    state
  end

  defp run(["detail", issue_id], state) do
    with {:ok, issues} <- Map.fetch(state, :credo_enhanced),
         {:ok, issue} <- get_issue(issue_id, issues)
    do
      display_detail(issue)
    else 
      _err -> IO.puts("No matching issue (ID=#{issue_id})")
    end

    state
  end

  defp run(["apply", op_id], state) do
    
    with {:ok, issues} <- Map.fetch(state, :credo_enhanced),
         [id | _] <- String.split(op_id, "."),  
         {:ok, issue} <- get_issue(id, issues), 
         {:ok, _key} <- Enum.find_value(issue[:operation_keys], &(op_id == &1 && {:ok, &1}))
    do
      run_operation(issue, op_id)
    else 
      _err -> IO.puts("No matching operation (ID=#{op_id})")
    end

    state
  end

  defp run(["suggest"], state) do
    results = RfxCli.Util.Credo.run()
    enhanced = results |> augment_credo()
    display = enhanced |> display_credo()
    display |> render_credo()
    Map.merge(state, %{credo_results: results, credo_enhanced: enhanced, credo_display: display})
  end

  defp run(["xx"], _state) do
    :halt
  end

  defp run(["exit"], _state) do
    :halt
  end

  defp run(cmd, state) do
    output = cmd |> Enum.join(" ")
    IO.puts(~s(Unknown command: "#{output}" - type '?' for help...))
    state
  end

  def run_operation(issue, op_id) do
    IO.puts "RUN OPERATION #{op_id}"
    IO.inspect issue
  end

  def get_issue(issue_id, issues) do
    id = issue_id |> String.to_integer()

    issues
    |> Enum.find_value(&(id == &1[:id] && {:ok, &1}))
  end

  defp augment_credo(data) do
    data
    |> Enum.map(fn {_key, val} -> val end)
    |> flatten()
    |> Enum.map(&Map.from_struct(&1))
    |> Enum.with_index(1)
    |> Enum.map(&attach_id(&1))
    |> Enum.map(&attach_operations(&1))
    |> Enum.map(&attach_operation_labels(&1))
    |> Enum.map(&attach_operation_keys(&1))
  end

  def attach_id({issue, id}) do
    Map.merge(issue, %{id: id})
  end

  def attach_operations(issue) do
    operations = Rfx.Catalog.OpsCat.find_by_prop(:credo_check, issue.check)
    Map.merge(issue, %{operations: operations})
  end

  def attach_operation_labels(issue) do
    labels = issue |> gen_op_labels()
    Map.merge(issue, %{operation_labels: labels})
  end

  def attach_operation_keys(issue) do
    keys = issue |> gen_op_keys()
    Map.merge(issue, %{operation_keys: keys})
  end

  defp gen_op_labels(issue) do
    id = Map.get(issue, :id)

    issue.operations
    |> Enum.map(&(&1 |> Atom.to_string() |> String.replace("Elixir.Rfx.Ops.Credo.", "")))
    |> Enum.with_index()
    |> Enum.map(fn {el, idx} -> "#{id}.#{idx} #{el}" end)
  end

  defp gen_op_keys(issue) do
    issue[:operation_labels]
    |> Enum.map(&(String.split(&1, " ") |> List.first()))
  end

  defp display_credo(data) do
    data
    |> Enum.map(&display_list_from_issue(&1))
  end

  def display_list_from_issue(issue) do
    [
      issue.id,
      shortfile(issue[:filename]),
      shortcheck(issue[:check]),
      issue[:operation_labels] |> Enum.join(", ")
    ]
  end

  defp shortfile(filename) do
    filename
    |> String.split("/")
    |> Enum.take(-2)
    |> Enum.join("/")
  end

  defp shortcheck(check) do
    check
    |> Atom.to_string()
    |> String.replace("Elixir.Credo.Check.", "")
  end

  defp render_credo(rows) do
    [_ | [_ | rest]] = Path.expand(".") |> Path.split()
    path = "~/#{Enum.join(rest, "/")}"

    date =
      :calendar.local_time() |> NaiveDateTime.from_erl!() |> Calendar.strftime("%b %d %a %H:%M")

    title = "Credo Issues       #{path}       #{date}"
    header = ["ID", "File", "Credo Check", "Rfx Operation"]

    if Enum.any?(rows) do
      TableRex.quick_render!(rows, header, title)
    else
      "Congrats!  No Credo issues!!"
    end
    |> IO.puts()
  end

  defp display_detail(issue) do
    IO.inspect(issue, label: "ISSUE_DETAIL")
  end

  defp flatten(list), do: flatten(list, [])
  defp flatten([h | t], acc), do: flatten(t, h ++ acc)
  defp flatten([], acc), do: acc
end
