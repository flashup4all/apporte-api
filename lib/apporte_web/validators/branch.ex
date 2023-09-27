defmodule ApporteWeb.Validators.CreateBranch do
  @moduledoc """
    ResetPassword Validator
  """
  use Apporte.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :name, :string
    field :address, :string
    field :state, :string
    field :country, :string
    field :is_active, :boolean
  end

  @required_fields [:name, :address, :state, :country]
  @cast_fields [:is_active] ++ @required_fields
  @doc false
  def cast_and_validate(attrs) do
    %__MODULE__{}
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
    |> apply_changes_if_valid()
  end
end
