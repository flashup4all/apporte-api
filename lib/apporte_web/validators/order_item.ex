defmodule ApporteWeb.Validators.OrderItem do
  @moduledoc """
    ResetPassword Validator
  """
  use Apporte.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :name, :string
    field :amount, Money.Ecto.Amount.Type
    field :description, :string
    field :quantity, :integer
  end

  @required_fields [:name, :amount, :quantity]
  @cast_fields [:description] ++ @required_fields
  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
  end
end
