defmodule UltimateChat.RoomsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `UltimateChat.Rooms` context.
  """

  @doc """
  Generate a room.
  """
  def room_fixture(attrs \\ %{}) do
    user = UltimateChat.UsersFixtures.user_fixture()

    {:ok, room} =
      attrs
      |> Enum.into(%{
        name: Faker.Team.name(),
        creator_id: user.id
      })
      |> UltimateChat.Rooms.create_room()

    room
  end
end
