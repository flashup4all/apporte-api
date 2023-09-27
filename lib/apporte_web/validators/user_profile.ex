defmodule ApporteWeb.Validators.UserProfile do
  @moduledoc """
    UserProfile Validator
  """
  use Apporte.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :dob, :naive_datetime
    field :gender, Ecto.Enum, values: [:male, :female, :non_binary, :others, :prefer_not_to_say]
    field :state_province_of_origin, :string
    field :address, :string
    field :country, :string
    field :role, :string
    field :branch_id, Ecto.UUID
    field :from_date, :date
    field :to_date, :date
    field :page, :integer
    field :limit, :integer, default: 15
  end

  @required_fields [:first_name, :last_name]
  @cast_fields [
                 :dob,
                 :gender,
                 :state_province_of_origin,
                 :address,
                 :country,
                 :from_date,
                 :to_date,
                 :page,
                 :limit,
                 :email,
                 :role
               ] ++ @required_fields

  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
  end

  def filter_cast_and_validate(attrs) do
    %__MODULE__{}
    |> cast(attrs, @cast_fields)
    |> validate_required([:page])
    |> apply_changes_if_valid()
  end
end
