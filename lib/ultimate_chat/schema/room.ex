defmodule UltimateChat.Schema.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :name, :string
    belongs_to :users, UltimateChat.Schema.User, foreign_key: :creator_id

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :creator_id])
    |> validate_required([:name, :creator_id])
    |> unique_constraint(:name)
  end
end
