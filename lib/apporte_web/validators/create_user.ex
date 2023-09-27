defmodule ApporteWeb.Validators.CreateUser do
  @moduledoc """
    CreateUser Validator
  """
  use Apporte.Schema
  import Ecto.Changeset
  alias ApporteWeb.Validators.{UserProfile, CreateStaffProfile}

  @primary_key false
  embedded_schema do
    field :email, :string
    field :password, :string
    field :user_type, Ecto.Enum, values: [:user, :business]
    field :role, Ecto.Enum, values: [:rider, :admin, :super_admin, :user, :branch_admin, :customer]
    field :phone_number, :string
    embeds_one(:user_profile, UserProfile)
    embeds_one(:staff_profile, CreateStaffProfile)
  end

  @required_fields [:email, :password, :user_type, :role, :phone_number]
  @cast_fields @required_fields
  @doc false
  def cast_and_validate(attrs) do
    %__MODULE__{}
    |> cast(attrs, @cast_fields)
    |> cast_embed(:user_profile, required: true)
    |> validate_required(@required_fields)
    |> update_change(:email, &String.downcase(&1 || ""))
    |> validate_format(
      :email,
      ~r/^[\w.!#$%&'*+\-\/=?\^`{|}~]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*$/i
    )
    |> validate_password()
    |> apply_changes_if_valid()
  end

  defp validate_password(changeset) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 72)
    |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/,
      message: "at least one digit or punctuation character"
    )
  end

  def create_staff_cast_and_validate(attrs) do
    %__MODULE__{}
    |> cast(attrs, @cast_fields)
    |> cast_embed(:staff_profile, required: true)
    |> validate_required(@required_fields)
    |> update_change(:email, &String.downcase(&1 || ""))
    |> validate_format(
      :email,
      ~r/^[\w.!#$%&'*+\-\/=?\^`{|}~]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*$/i
    )
    |> validate_password()
    |> apply_changes_if_valid()
  end
end
