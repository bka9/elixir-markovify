defmodule Markovify.Mixfile do
  use Mix.Project

  def project do
    [app: :markovify,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     deps: deps(),
     package: package()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger],
     mod: {Markovify, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:ex_doc, "~> 0.12", only: :dev}]
  end

  defp description do
    """
      A markov chain theory based library to generate new sentences from a body of text.
    """
  end

  defp package do
    [# These are the default files included in the package
     name: :markovify,
     files: ["lib", "mix.exs", "README*", "LICENSE*"],
     maintainers: ["Kevin Anderson"],
     licenses: ["GNU GPLv3"],
     links: %{"GitHub" => "https://github.com/bka9/elixir-markovify"}]
  end
end
