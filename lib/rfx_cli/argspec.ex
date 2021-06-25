defmodule RfxCli.Argspec do
  def gen do
    Optimus.new!(common() ++ subcommands())
  end

  def common do
    [
      name: "rfx",
      version: "0.0.1",
      description: "Refactoring operations for Elixir Code.",
      about: """
      """,
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
      ]
    ]
  end

  def subcommands do
    [
      subcommands: RfxCli.Oplst.subcommands(RfxCli.Oplst.all_ops())
    ]
  end
end
