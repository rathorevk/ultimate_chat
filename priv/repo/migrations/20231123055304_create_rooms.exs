defmodule UltimateChat.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string
      add :creator_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:rooms, [:creator_id])
    create unique_index(:rooms, [:name])
  end
end
