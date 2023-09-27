defmodule Apporte.Repo.Migrations.CreateOrderItemsTable do
  use Ecto.Migration

  def change do
    create table(:order_items) do
      add :name, :string
      add :description, :string
      add :amount, :integer
      add :quantity, :integer
      add :metadata, :map
      add :order_id, references(:orders)
      add :deleted_at, :utc_datetime_usec, null: true

      timestamps()
    end
  end
end
