defmodule Apporte.Accounts.UserProfile do
  @moduledoc false
  alias Apporte.Repo
  use Apporte.Schema

  import Ecto.Changeset
  import Ecto.Query
  import Apporte.DynamicFilter

  alias Apporte.Accounts.{User, Branch}

  @type t :: %__MODULE__{}

  schema "user_profiles" do
    field :address, :string
    field :country, :string
    field :dob, :naive_datetime
    field :first_name, :string
    field :gender, Ecto.Enum, values: [:male, :female, :non_binary, :others, :prefer_not_to_say]
    field :last_name, :string
    field :metadata, :map, default: %{}
    field :state_province_of_origin, :string
    belongs_to(:user, User)
    belongs_to(:branch, Branch)

    timestamps()
  end

  def fields, do: __MODULE__.__schema__(:fields)

  @required_fields [:first_name, :last_name]
  @cast_fields [:user_id, :dob, :gender, :state_province_of_origin, :address, :country, :metadata] ++
                 @required_fields
  @spec changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(%User{} = user, params) do
    %__MODULE__{}
    |> cast(params, @cast_fields)
    |> validate_required(@required_fields)
    |> put_assoc(:user, user)
  end

  def changeset(%User{} = user, %Branch{} = branch, params) do
    %__MODULE__{}
    |> cast(params, @cast_fields)
    |> validate_required(@required_fields)
    |> put_assoc(:user, user)
    |> put_assoc(:branch, branch)
  end

  def create_staff_profile(%User{} = user, %Branch{} = branch, params) do
    changeset(user, branch, params)
    |> Repo.insert()
  end

  def create_user_profile(%User{} = user, params) do
    changeset(user, params)
    |> Repo.insert()
  end

  def get_user_profile_by_user_id(user_id) do
    case Repo.get_by(__MODULE__, user_id: user_id) do
      %__MODULE__{} = user_profile -> {:ok, user_profile}
      nil -> {:error, :not_found}
    end
  end

  def get_user_profile(user_profile_id) do
    case Repo.one(
           __MODULE__
           |> where([user_profile], user_profile.id == ^user_profile_id)
           |> preload()
         ) do
      %__MODULE__{} = user_profile -> {:ok, user_profile}
      nil -> {:error, :not_found}
    end
  end

  def update(%__MODULE__{} = user_profile, update_params) do
    user_profile
    |> cast(update_params, @cast_fields)
    |> validate_required(@required_fields)
    |> Repo.update()
  end

  def preload(query) do
    query |> preload([user_profile], [:user, :branch])
  end

  def list_staffs(params) do
    query =
      __MODULE__
      # |> where([user_profile], user_profile.role not in [:admin])
      |> filter(:first_name, :ilike, params.first_name)
      |> or_assoc_filter(:user, :email, :ilike, params.email)
      |> assoc_filter(:user, :role, :eq, params.role)
      |> filter(:id, :eq, params.branch_id)
      |> filter(:range, :date, params.from_date, params.to_date)
      |> preload()

    Repo.paginate(query, page: params.page, page_size: params.limit)
  end
end
