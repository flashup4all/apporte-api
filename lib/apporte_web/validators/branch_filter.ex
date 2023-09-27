defmodule ApporteWeb.Validators.BranchFilter do
  @moduledoc """
    BranchFilter Validator
  """
  use Apporte.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :branch_id, Ecto.UUID
    field :user_id, Ecto.UUID
    field :name, :string
    field :address, :string
    field :is_active, :boolean
    field :from_date, :date
    field :to_date, :date
    field :page, :integer
    field :limit, :integer, default: 15
  end

  @required_fields [:page]
  @cast_fields [:limit, :branch_id, :name, :address, :from_date, :to_date, :is_active] ++
                 @required_fields
  @doc false
  def cast_and_validate(attrs) do
    %__MODULE__{}
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
    |> apply_changes_if_valid()
  end
end
