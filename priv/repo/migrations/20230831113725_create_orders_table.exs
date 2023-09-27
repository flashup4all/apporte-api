defmodule Apporte.Repo.Migrations.CreateOrdersTable do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :reference, :string
      add :total_insurance_fee, :string
      add :total_vat, :string
      add :total_delivery_fee, :string
      add :sub_total, :string
      add :discount_amount, :string
      add :discount_percent, :string
      add :total, :string
      add :pickup_contact_name, :string
      add :pickup_contact_phone_no, :string
      add :pickup_contact_email, :string
      add :pickup_address, :string
      add :pickup_state, :string
      add :pickup_country, :string, default: "NGN"
      add :delivery_contact_name, :string
      add :delivery_contact_phone_no, :string
      add :delivery_contact_email, :string
      add :delivery_address, :string
      add :delivery_state, :string
      add :delivery_country, :string
      add :channel, :string
      add :is_office_pickup, :boolean
      add :metadata, :map
      add :user_id, references(:users)
      add :rider_id, references(:users)
      add :deleted_at, :utc_datetime_usec, null: true

      timestamps()
    end
  end
end
