defmodule Apporte.Accounts.Branch do
  @moduledoc false
  alias Apporte.Repo
  use Apporte.Schema

  import Ecto.Changeset
  import Ecto.Query
  import Apporte.DynamicFilter
  alias Apporte.Accounts.User

  @type t :: %__MODULE__{}

  schema "branches" do
    field :address, :string
    field :name, :string
    field :state, :string
    field :country, :string
    field :is_active, :boolean, default: true
    field :deleted_at, :utc_datetime

    belongs_to(:user, Apporte.Accounts.User)

    timestamps()
  end

  def fields, do: __MODULE__.__schema__(:fields)

  @required_fields [:address, :name, :state, :country]
  @cast_fields [:is_active, :deleted_at] ++
                 @required_fields

  @doc false
  def changeset(%User{} = user, params) do
    %__MODULE__{}
    |> cast(params, @cast_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name,
      name: :branches_name_index,
      message: "a branch with this name already exist."
    )
    |> put_assoc(:user, user)
  end

  def create(%User{} = user, params) do
    changeset(user, params)
    |> Repo.insert()
  end

  def get_branch(id) do
    case Repo.one(__MODULE__ |> where([branch], branch.id == ^id) |> preload()) do
      %__MODULE__{} = branch -> {:ok, branch}
      nil -> {:error, :not_found}
    end
  end

  def update(%__MODULE__{} = branch, params) do
    branch
    |> cast(params, @cast_fields)
    |> validate_required(@required_fields)
    |> Repo.update()
  end

  def preload(query) do
    query |> preload([branch], [:user])
  end

  def get_branches(params) do
    query =
      __MODULE__
      |> filter(:id, :eq, params.branch_id)
      |> filter(:user_id, :eq, params.user_id)
      |> filter(:is_active, :eq, params.is_active)
      |> filter(:range, :date, params.from_date, params.to_date)
      |> preload()

    Repo.paginate(query, page: params.page, page_size: params.limit)
  end
end
