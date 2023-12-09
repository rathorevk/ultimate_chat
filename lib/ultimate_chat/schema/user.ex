defmodule UltimateChat.Schema.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_format(:name, ~r/^[a-zA-Z0-9]+$/, message: "only letters and numbers allowed!")
  end
end
