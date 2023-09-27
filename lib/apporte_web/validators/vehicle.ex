defmodule ApporteWeb.Validators.Vehicle do
  @moduledoc """
    ResetPassword Validator
  """
  use Apporte.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :type, Ecto.Enum, values: [:tricycle, :motorcycle, :truck, :bus, :car]
    field :name, :string
    field :chassis_no, :string
    field :plate_no, :string
    field :description, :string
    field :branch_id, Ecto.UUID
    field :status, Ecto.Enum, values: [:active, :decommisioned, :repiars], default: :active
    field :is_active, :boolean, default: true

    # filter
    field :user_id, Ecto.UUID
    field :from_date, :date
    field :to_date, :date
    field :page, :integer
    field :limit, :integer, default: 15
  end

  @required_fields [:type, :chassis_no, :plate_no, :branch_id]
  @cast_fields [:name, :description, :status, :is_active] ++ @required_fields
  @doc false
  def cast_and_validate(attrs) do
    %__MODULE__{}
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
    |> apply_changes_if_valid()
  end

  def cast_and_validate_update(attrs) do
    %__MODULE__{}
    |> cast(attrs, @cast_fields)
    # |> validate_required([])
    |> apply_changes_if_valid()
  end

  def cast_and_validate_filter(attrs) do
    %__MODULE__{}
    |> cast(attrs, [
      :status,
      :is_active,
      :type,
      :chassis_no,
      :plate_no,
      :branch_id,
      :user_id,
      :from_date,
      :to_date,
      :page,
      :limit
    ])
    |> validate_required([:page])
    |> apply_changes_if_valid()
  end
end
