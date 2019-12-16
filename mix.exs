defmodule ExBinance.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_binance,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:websockex, "~> 0.4.0"},
      {:tesla, "~> 1.3.0"},
      {:hackney, "~> 1.14.0"},
      {:jason, ">= 1.0.0"},
      {:decimal, "~> 1.0"}
    ]
  end
end
