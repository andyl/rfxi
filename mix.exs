defmodule Rfxi.MixProject do
  use Mix.Project

  def project do
    [
      app: :rfxi,
      version: "0.0.1",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      source_url: "https://github.com/andyl/rfxi",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      escript: escript(),
      docs: docs(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Rfxi.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  def escript do
    [
      # main_module: RfxCli.Base,
      main_module: RfxCli.Server, 
      name: "rfx" 
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: [
        "README.md",
        "guides/integration.md"
      ]
    ]
  end

  defp deps do
    [
      # --- phoenix dependencies 
      {:phoenix, "~> 1.5.9"},
      {:phoenix_live_view, "~> 0.15.1"},
      {:floki, ">= 0.30.0", only: :test},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_dashboard, "~> 0.4"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"}, 
      # --- cli dependencies
      {:rfx, path: "~/src/rfx"},
      {:optimus, "~> 0.2"}, 
      # --- utilities
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      {:mix_test_interactive, "~> 1.0", only: :dev, runtime: false}, 
      {:mix_npm, "~> 0.3"}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "cmd npm install --prefix assets"], 
      esprep: ["npm.run deploy --prefix ./assets", "phx.digest"],
      esbuild: ["esprep", "escript.build"]
    ]
  end
end
