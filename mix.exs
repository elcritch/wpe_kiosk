defmodule WpeKiosk.MixProject do
  use Mix.Project

  def project do
    [
      app: :wpe_kiosk,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
    """
    Simple wrapper around Cog which is a WPE launcher and webapp container. Runs a fullscreen kiosk-style brwoser with hardware GPU acceleration and multimedia extensions. WebGL works.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*", "test", "Makefile"],
      maintainers: ["Jaremy Creechley"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/elcritch/wpe_kiosk"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
