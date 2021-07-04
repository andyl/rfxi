defmodule RfxCli.Repl do
  def start do
    start("begin", 1)
  end

  def start("exit", _) do
    IO.puts("EXITING.")
  end

  def start("begin", _) do
    IO.puts("STARTING RFX REPL")

    if Application.get_env(:rfxi, :env) != :test do
      start(:ok, 0)
    end
  end

  def start(_, count) do
    command = get_input(count)

    case run(command) do
      :halt -> IO.puts("DONE")
      _ -> start("continue", count + 1)
    end
  end

  def get_input(count) do
    IO.gets("rfx_#{count}> ")
    |> String.trim()
  end

  def run("") do
    :no_cmd
  end

  def run("exit") do
    :halt
  end

  def run(command) do
    RfxCli.Base.main(command)
  end
end
