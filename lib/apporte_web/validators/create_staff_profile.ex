defmodule ApporteWeb.Validators.CreateStaffProfile do
  @moduledoc """
    UserProfile Validator
  """
  use Apporte.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :first_name, :string
    field :last_name, :string
    field :dob, :naive_datetime
    field :gender, Ecto.Enum, values: [:male, :female, :non_binary, :others, :prefer_not_to_say]
    field :state_province_of_origin, :string
    field :address, :string
    field :country, :string
    field :branch_id, Ecto.UUID
  end

  @required_fields [
    :first_name,
    :last_name,
    :branch_id,
    :gender,
    :address,
    :state_province_of_origin
  ]
  @cast_fields [:dob, :gender, :state_province_of_origin, :address, :country] ++ @required_fields

  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
  end
end
