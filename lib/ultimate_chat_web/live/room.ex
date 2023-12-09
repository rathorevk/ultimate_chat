defmodule UltimateChatWeb.Live.Room do
  use UltimateChatWeb, :live_view

  import UltimateChatWeb.ComponentHelpers

  alias UltimateChat.PubSub
  alias UltimateChat.Schema.Message
  alias UltimateChat.Messages
  alias UltimateChat.Rooms

  require Logger

  @impl true
  def mount(%{"room_id" => room_id}, %{"user_id" => user_id} = _session, socket) do
    Logger.info("User: #{user_id} in chat room: #{room_id}")
    room_id = String.to_integer(room_id)

    current_room = Rooms.get_room!(room_id)

    if connected?(socket) do
      :ok = PubSub.subscribe_to_message_updates(room_id)
    end

    message = %Message{room_id: room_id, sender_id: user_id}

    message_form =
      message
      |> Messages.change_message()
      |> to_form()

    %{entries: entries, metadata: metadata} = Messages.list_messages_by_room(room_id)

    {:ok,
     socket
     |> assign(:current_user, user_id)
     |> assign(:user_id, user_id)
     |> assign(:current_room, current_room)
     |> assign(:message_struct, message)
     |> assign(:form, message_form)
     |> assign(:messages, entries)
     |> assign(:metadata, metadata)}
  end

  @impl true
  def handle_event("save", %{"message" => message_text}, socket) do
    Logger.info("Save message: #{inspect(message_text)}")

    case Messages.create_message(socket.assigns.message_struct, %{text: message_text}) do
      {:ok, new_message} ->
        message = Messages.get_message!(new_message.id)
        PubSub.broadcast_message_update(socket.assigns.current_room.id, {:new_message, message})

        {:noreply, socket |> put_flash(:info, "Message sent!")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_event("load_messages", _params, socket) do
    Logger.info("Load more message: #{socket.assigns.metadata.after}")
    metadata = [after: socket.assigns.metadata.after]

    %{entries: entries, metadata: metadata} =
      Messages.list_messages_by_room(socket.assigns.current_room.id, metadata)

    {:noreply,
     socket
     |> assign(:messages, socket.assigns.messages ++ entries)
     |> assign(:metadata, metadata)}
  end

  def handle_event("back", _unsigned_params, socket) do
    {:noreply, socket |> push_navigate(to: ~p"/rooms")}
  end

  @impl true
  def handle_info({:new_message, message}, socket) do
    Logger.info(
      "Recieved new message: #{inspect(message)} in room: #{socket.assigns.current_room.id}"
    )

    messages = [message | socket.assigns.messages]
    socket = socket |> assign(:messages, messages)

    if message.sender_id == socket.assigns.user_id do
      {:noreply, socket}
    else
      {:noreply, socket |> put_flash(:info, "Recieved new Message")}
    end
  end
end
