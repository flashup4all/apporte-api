defmodule Apporte.Accounts.Vehicle do
  @moduledoc false
  alias Apporte.Repo
  use Apporte.Schema

  import Ecto.Changeset
  import Ecto.Query
  import Apporte.DynamicFilter
  alias Apporte.Accounts.User
  alias Apporte.Accounts.Branch

  @type t :: %__MODULE__{}

  schema "vehicles" do
    field :type, Ecto.Enum, values: [:tricycle, :motorcycle, :truck, :bus, :car]
    field :name, :string
    field :chassis_no, :string
    field :plate_no, :string
    field :description, :string
    field :status, Ecto.Enum, values: [:active, :decommisioned, :repiars], default: :active
    field :is_active, :boolean, default: true
    field :deleted_at, :utc_datetime

    belongs_to(:user, User)
    belongs_to(:branch, Branch)

    timestamps()
  end

  def fields, do: __MODULE__.__schema__(:fields)

  @required_fields [:type, :chassis_no, :plate_no]
  @cast_fields [:name, :description, :status, :is_active, :deleted_at] ++
                 @required_fields

  @doc false
  def changeset(%User{} = user, %Branch{} = branch, params) do
    %__MODULE__{}
    |> cast(params, @cast_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:chassis_no,
      name: :vehicles_chassis_no_index,
      message: "A vehicle with this chassis no. already exist."
    )
    |> unique_constraint(:plate_no,
      name: :vehicles_plate_no_index,
      message: "A vehicle with this plate no.  already exist."
    )
    |> put_assoc(:branch, branch)
    |> put_assoc(:user, user)
  end

  def create(%User{} = user, %Branch{} = branch, params) do
    changeset(user, branch, params)
    |> Repo.insert()
  end

  def get_vehicle(id) do
    case Repo.one(
           __MODULE__
           |> where([vehicle], vehicle.id == ^id and is_nil(vehicle.deleted_at))
           |> preload()
         ) do
      %__MODULE__{} = vehicle -> {:ok, vehicle}
      nil -> {:error, :not_found}
    end
  end

  def update(%__MODULE__{} = vehicle, params) do
    vehicle
    |> cast(params, @cast_fields)
    |> validate_required(@required_fields)
    |> Repo.update()
  end

  def preload(query) do
    # query |> preload([vehicle], [:user, :branch])
    query
  end

  def get_vehicles(params) do
    query =
      __MODULE__
      |> where([vehicle], is_nil(vehicle.deleted_at))
      |> filter(:id, :eq, params.branch_id)
      |> filter(:user_id, :eq, params.user_id)
      |> filter(:is_active, :eq, params.is_active)
      |> filter(:range, :date, params.from_date, params.to_date)
      |> preload()

    Repo.paginate(query, page: params.page, page_size: params.limit)
  end
end
