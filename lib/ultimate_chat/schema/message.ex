defmodule UltimateChat.Schema.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :text, :string

    belongs_to :user, UltimateChat.Schema.User, foreign_key: :sender_id
    belongs_to :room, UltimateChat.Schema.Room, foreign_key: :room_id

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:text, :sender_id, :room_id])
    |> validate_required([:text, :sender_id, :room_id])
  end
end
