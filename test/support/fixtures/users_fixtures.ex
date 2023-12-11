defmodule UltimateChat.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `UltimateChat.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        name: Faker.Person.first_name()
      })
      |> UltimateChat.Users.create_user()

    user
  end
end
