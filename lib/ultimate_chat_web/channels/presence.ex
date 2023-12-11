defmodule UltimateChatWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.

  See the [`Phoenix.Presence`](https://hexdocs.pm/phoenix/Phoenix.Presence.html)
  docs for more details.
  """
  use Phoenix.Presence,
    otp_app: :ultimate_chat,
    pubsub_server: UltimateChat.PubSub

  require Logger

  @impl true
  def init(_opts) do
    {:ok, %{}}
  end

  @impl true
  def fetch(_topic, presences) do
    for {key, %{metas: [meta | metas]}} <- presences, into: %{} do
      {key, %{metas: [meta | metas], id: meta.id, user: %{name: meta.name}}}
    end
  end

  @impl true
  def handle_metas(topic, %{joins: joins, leaves: leaves}, presences, state) do
    Logger.debug("User presence joins: #{inspect(joins)} leaves: #{inspect(leaves)}")

    for {user_id, presence} <- joins do
      user_data = %{
        id: String.to_integer(user_id),
        user: presence.user,
        metas: Map.fetch!(presences, user_id)
      }

      msg = {__MODULE__, {:join, user_data}}

      Phoenix.PubSub.local_broadcast(UltimateChat.PubSub, "proxy:#{topic}", msg)
    end

    for {user_id, presence} <- leaves do
      metas =
        case Map.fetch(presences, user_id) do
          {:ok, presence_metas} -> presence_metas
          :error -> []
        end

      user_data = %{id: user_id, user: presence.user, metas: metas}
      msg = {__MODULE__, {:leave, user_data}}
      Phoenix.PubSub.local_broadcast(UltimateChat.PubSub, "proxy:#{topic}", msg)
    end

    {:ok, state}
  end

  def list_online_users(),
    do: list("online_users") |> Enum.map(fn {_id, presence} -> presence end)

  def track_user(name, params), do: track(self(), "online_users", name, params)

  def subscribe(), do: Phoenix.PubSub.subscribe(UltimateChat.PubSub, "proxy:online_users")
end
