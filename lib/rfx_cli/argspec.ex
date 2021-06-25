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

  def subcommand_options do
    [
      args: [
        target: [
          value_name: "TARGET",
          short: "-t",
          long: "--target",
          help: "Operation target", 
          parser: :string
        ]
      ],
      flags: [
        quiet: [
          short: "-q", 
          long: "--quiet",
          help: "Run without output"
        ],
        apply: [
          short: "-a",
          long: "--apply",
          help: "Apply the changeset to the filesystem"
        ]
      ], 
      options: [
        scope: [
          short: "-s",
          long: "--scope",
          value_name: "SCOPE",
          help: "Refactoring scope",
          parser: :string
        ], 
        convert: [
          short: "-c",
          long: "--convert",
          value_name: "OPTIONS",
          help: "Changelist processing options",
          parser: :string
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
