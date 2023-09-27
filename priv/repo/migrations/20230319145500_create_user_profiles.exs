defmodule Apporte.Repo.Migrations.CreateUserProfiles do
  use Ecto.Migration

  def change do
    create table(:user_profiles) do
      add :first_name, :string
      add :last_name, :string
      add :dob, :naive_datetime
      add :gender, :string
      add :state_province_of_origin, :string
      add :address, :string
      add :country, :string
      add :metadata, :map
      add :user_id, references(:users)
      add :branch_id, references(:branches)

      timestamps()
    end

    create index(:user_profiles, [:user_id])
  end
end
