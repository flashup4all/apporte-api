defmodule Apporte.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :password_hash, :binary
      add :user_type, :string
      add :role, :string
      add :phone_number, :string
      add :is_active, :boolean, default: false, null: false
      add :is_bvn_verified, :boolean, default: false, null: false
      add :bvn, :string
      add :metadata, :map
      add :is_email_verified, :boolean, default: false, null: false
      add :is_phone_number_verified, :boolean, default: false, null: false
      add :deleted_at, :utc_datetime_usec, null: true

      timestamps()
    end

    create unique_index(:users, :email)
    create unique_index(:users, :phone_number)
  end
end
