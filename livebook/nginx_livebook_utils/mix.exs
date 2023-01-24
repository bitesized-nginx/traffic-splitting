defmodule NginxLivebookUtils.MixProject do
  use Mix.Project

  def project do
    [
      app: :nginx_livebook_utils,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {NginxLivebookUtils.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mint, "~> 1.4"}
    ]
  end
end
