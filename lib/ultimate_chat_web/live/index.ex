defmodule UltimateChatWeb.Live.Index do
  use UltimateChatWeb, :live_view

  alias UltimateChat.Rooms
  alias UltimateChat.Schema.Room
  alias UltimateChat.Users

  require Logger

  @impl true
  def mount(_params, %{"session_uuid" => session_uuid} = _session, socket) do
    Logger.info("User index with session_uuid: #{session_uuid}")

    user_id = socket.assigns[:user_id]
    {:ok, init_mount(socket, user_id)}
  end

  def mount(_params, %{"user_id" => user_id} = _session, socket) do
    Logger.info("User index with user_id: #{user_id}")

    {:ok, init_mount(socket, user_id)}
  end

  @impl true
  def handle_event("back", _unsigned_params, socket) do
    {:noreply, socket |> push_navigate(to: ~p"/logout")}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_info({UltimateChatWeb.Presence, {:join, presence}}, socket) do
    Logger.info("User joined: #{inspect(presence)}")
    {:noreply, stream_insert(socket, :presences, presence, at: 0)}
  end

  def handle_info({UltimateChatWeb.Presence, {:leave, presence}}, socket) do
    Logger.info("User leave: #{inspect(presence)}")

    if presence.metas == [] do
      {:noreply, stream_delete(socket, :presences, presence)}
    else
      {:noreply, stream_insert(socket, :presences, presence)}
    end
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Chat Room")
    |> assign(:room, %Room{creator_id: socket.assigns.user_id})
  end

  defp apply_action(socket, :join, _params) do
    socket
    |> assign(:page_title, "Listing Rooms")
    |> assign(:rooms, Rooms.list_rooms())
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Index")
    |> assign(:room, nil)
  end

  defp init_mount(socket, user_id) do
    current_user = Users.get_user!(user_id)

    socket = stream(socket, :presences, [])

    socket =
      if connected?(socket) do
        UltimateChatWeb.Presence.track_user(current_user.id, %{
          id: current_user.id,
          name: current_user.name
        })

        UltimateChatWeb.Presence.subscribe()
        stream(socket, :presences, UltimateChatWeb.Presence.list_online_users())
      else
        socket
      end

    socket |> assign(:user_id, user_id) |> assign(:current_user, current_user)
  end
end
