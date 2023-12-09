defmodule UltimateChatWeb.LiveComponent.Create do
  use UltimateChatWeb, :live_component

  alias UltimateChat.Rooms

  require Logger

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <header class="font-bold text-xl text-indigo-600">
        New Chat Room
      </header>

      <.simple_form
        for={@form}
        id="room-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <label class="text-indigo-600 text-sm font-bold">
          Room Name
          <.input field={@form[:name]} class="rounded border-indigo-300" type="text" required />
        </label>

        <:actions>
          <.button class="bg-indigo-500 hover:bg-green-400" phx-disable-with="Creating...">
            Create
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(%{room: room} = assigns, socket) do
    Logger.info("Update room: #{inspect(room)}")
    changeset = Rooms.change_room(room)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"room" => room_params}, socket) do
    Logger.debug("Validate room: #{inspect(room_params)}")

    changeset =
      socket.assigns.room
      |> Rooms.change_room(room_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"room" => room_params}, socket) do
    user_id = socket.assigns.user_id
    Logger.info("Save room: #{inspect(room_params)} user: #{user_id}")
    room_params = Map.put(room_params, "creator_id", user_id)

    case Rooms.create_room(room_params) do
      {:ok, room} ->
        {:noreply,
         socket
         |> put_flash(:info, "Room created successfully!")
         |> redirect(to: ~p"/room/#{room.id}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
