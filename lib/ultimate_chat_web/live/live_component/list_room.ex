defmodule UltimateChatWeb.LiveComponent.ListRoom do
  use UltimateChatWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="bg-white p-6 rounded-lg items-center">
      <h1 class="font-bold text-xl text-indigo-600 text-center mb-8">Active Chat Rooms</h1>
      <div class="w-full bg-white rounded-lg shadow-lg lg:w-4/5 ">
        <ul class="divide-y-2 divide-gray-100">
          <%= for room <- assigns.rooms do %>
            <li class="w-full p-3 hover:bg-indigo-300  hover:rounded">
              <.link href={~p"/room/#{room.id}"}>
                <span class="text-lg font-semibold mr-4">Room <%= room.id %>.</span>
                <span class="font-semibold"><%= room.name %></span>
              </.link>
            </li>
          <% end %>
        </ul>
      </div>
    </div>
    """
  end
end
