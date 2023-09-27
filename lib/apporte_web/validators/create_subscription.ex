defmodule ApporteWeb.Validators.CreateSubscription do
  @moduledoc """
    ResetPassword Validator
  """
  use Apporte.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :type, Ecto.Enum, values: [:eleven_trips, :others]
    field :customer_phone_number, Ecto.UUID
  end

  @required_fields [:type, :customer_id]
  @cast_fields [] ++ @required_fields
  @doc false
  def cast_and_validate(attrs) do
    %__MODULE__{}
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
    |> apply_changes_if_valid()
  end
end
