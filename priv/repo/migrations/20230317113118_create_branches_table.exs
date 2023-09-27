defmodule Apporte.Repo.Migrations.CreateBranchesTable do
  use Ecto.Migration

  def change do
    create table(:branches) do
      add :name, :string
      add :address, :string
      add :state, :string
      add :country, :string
      add :is_active, :boolean

      add :user_id, references(:users)
      add :deleted_at, :utc_datetime_usec, null: true

      timestamps()
    end

    create unique_index(:branches, :name)
  end
end
