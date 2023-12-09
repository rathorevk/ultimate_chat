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
    current_user = Users.get_user!(user_id)
    {:ok, socket |> assign(:user_id, user_id) |> assign(:current_user, current_user)}
  end

  def mount(_params, %{"user_id" => user_id} = _session, socket) do
    Logger.info("User index with user_id: #{user_id}")

    current_user = Users.get_user!(user_id)
    {:ok, socket |> assign(:user_id, user_id) |> assign(:current_user, current_user)}
  end

  @impl true
  def handle_event("back", _unsigned_params, socket) do
    {:noreply, socket |> push_navigate(to: ~p"/logout")}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
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
    |> assign(:page_title, "Lobby")
    |> assign(:room, nil)
  end
end
