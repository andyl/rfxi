defmodule RfxCli.ArgSpec do

  # def gen(state) do
  #   state
  #   |> args()
  #   |> Optimus.new!()
  # end
  #
  # def args(state) do 
  #   base_opts() ++ subcommands(state)
  # end 
  
  @moduledoc """
  Returns config and subcommands for Optimus options parser.
  """

  def base_config do
    [
      name: "rfx",
      version: "0.0.1",
      description: "Refactoring operations for Elixir Code.",
      author: "NA",
      about: """
      """,
      allow_unknown_args: false,
      flags: [
        # repl: [
        #   short: "-r",
        #   long: "--repl",
        #   help: "Run in REPL mode"
        # ],
        # server: [
        #   short: "-s",
        #   long: "--server",
        #   help: "Run web server"
        # ]
      ]
    ]
  end

  def base_subcommands do
    [
      repl: [
        name: "Repl",
        about: "Start repl"
      ],
      server: [
        name: "Server",
        about: "Start web server"
      ],
      # pipe: [
      #   name: "Pipe",
      #   about: "back door"
      # ]
    ]
  end

  def operation_config do
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
        oneline: [
          short: "-o",
          long: "--oneline",
          help: "Render JSON output in one line"
        ],
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

end
