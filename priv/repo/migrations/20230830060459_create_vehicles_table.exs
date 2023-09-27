defmodule Apporte.Repo.Migrations.CreateVehiclesTable do
  use Ecto.Migration

  def change do
    create table(:vehicles) do
      add :name, :string
      add :type, :string
      add :chassis_no, :string
      add :plate_no, :string
      add :description, :string
      add :status, :string
      add :is_active, :boolean
      add :user_id, references(:users)
      add :branch_id, references(:branches)
      add :deleted_at, :utc_datetime_usec, null: true

      timestamps()
    end

    create unique_index(:vehicles, :chassis_no)
    create unique_index(:vehicles, :plate_no)
  end
end
