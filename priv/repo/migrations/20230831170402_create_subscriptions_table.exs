defmodule Apporte.Repo.Migrations.CreateSubscriptionsTable do
  use Ecto.Migration

  def change do
    create table(:subcriptions) do
      add :type, :string
      add :description, :string
      add :amount, :integer
      add :feedback, :text
      add :rating, :integer
      add :is_active, :boolean
      add :is_expired, :boolean
      add :metadata, :map
      add :start_date, :utc_datetime_usec
      add :end_date, :utc_datetime_usec
      add :user_id, references(:users)
      add :transaction_id, references(:transactions)
      add :deleted_at, :utc_datetime_usec, null: true

      timestamps()
    end
  end
end
