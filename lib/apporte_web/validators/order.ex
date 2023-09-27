defmodule ApporteWeb.Validators.CreateOrder do
  @moduledoc """
    ResetPassword Validator
  """
  use Apporte.Schema
  import Ecto.Changeset
  alias ApporteWeb.Validators.OrderItem

  @primary_key false
  embedded_schema do
    field :pickup_contact_name, :string
    field :pickup_contact_phone_no, :string
    field :pickup_contact_email, :string
    field :pickup_address, :string
    field :pickup_state, :string
    field :delivery_contact_name, :string
    field :delivery_contact_phone_no, :string
    field :delivery_contact_email, :string
    field :delivery_address, :string
    field :delivery_state, :string
    field :is_office_pickup, :boolean
    field :channel, Ecto.Enum, values: [:web, :admin_web]
    embeds_many(:items, OrderItem)
  end

  @required_fields [
    :pickup_contact_name,
    :pickup_contact_phone_no,
    :pickup_contact_email,
    :pickup_address,
    :pickup_state,
    :delivery_contact_name,
    :delivery_contact_phone_no,
    :delivery_contact_email,
    :delivery_address,
    :delivery_state,
    :is_office_pickup,
    :channel
  ]
  @cast_fields [] ++ @required_fields
  @doc false
  def cast_and_validate(attrs) do
    %__MODULE__{}
    |> cast(attrs, @cast_fields)
    |> cast_embed(:items, required: true)
    |> validate_required(@required_fields)

    |> apply_changes_if_valid()
  end
end
