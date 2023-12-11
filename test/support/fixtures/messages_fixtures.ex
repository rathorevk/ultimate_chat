defmodule UltimateChat.MessagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `UltimateChat.Messages` context.
  """

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    user = UltimateChat.UsersFixtures.user_fixture()
    room = UltimateChat.RoomsFixtures.room_fixture()

    {:ok, message} =
      attrs
      |> Enum.into(%{
        text: Faker.StarWars.quote(),
        sender_id: user.id,
        room_id: room.id
      })
      |> UltimateChat.Messages.create_message()

    %{message | user: user}
  end
end
