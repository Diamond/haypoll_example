defmodule Haypoll.Repo.Migrations.CreateEntry do
  use Ecto.Migration

  def change do
    create table(:entries) do
      add :title, :string
      add :votes, :integer
      add :poll_id, references(:polls)

      timestamps
    end
    create index(:entries, [:poll_id])

  end
end
