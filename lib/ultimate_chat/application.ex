defmodule UltimateChat.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      UltimateChatWeb.Telemetry,
      # Start the Ecto repository
      UltimateChat.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: UltimateChat.PubSub},
      # Start Finch
      {Finch, name: UltimateChat.Finch},
      # Start the Endpoint (http/https)
      UltimateChatWeb.Endpoint,
      # Start a worker by calling: UltimateChat.Worker.start_link(arg)
      # {UltimateChat.Worker, arg}
      UltimateChatWeb.Presence
    ]

    UltimateChatWeb.ETS.UserAuth.new()
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UltimateChat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    UltimateChatWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
