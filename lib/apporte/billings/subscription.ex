defmodule Apporte.Billings.Subscription do
  @moduledoc false
  alias Apporte.Repo
  use Apporte.Schema

  import Ecto.Changeset
  import Ecto.Query
  import Apporte.DynamicFilter
  alias Apporte.Accounts.User
  alias Apporte.Billings.Transaction

  @type t :: %__MODULE__{}

  schema "subscriptions" do
    field :amount, Money.Ecto.Amount.Type
    field :type, Ecto.Enum, values: [:eleven_trips, :others]
    field :description, :string
    field :feedback, :string
    field :rating, :integer
    field :is_active, :boolean
    field :is_expired, :boolean
    field :metadata, :map
    field :start_date, :utc_datetime_usec
    field :end_date, :utc_datetime_usec
    field :deleted_at, :utc_datetime_usec, null: true
    belongs_to(:user, User)
    belongs_to(:transaction, Transaction)
    timestamps()
  end

  def fields, do: __MODULE__.__schema__(:fields)

  @required_fields [:amount, :type, :description, :amount, :start_date, :end_date]
  @cast_fields [:feedback, :rating, :is_active, :is_expired, :metadata, :deleted_at] ++
                 @required_fields

  @doc false
  def changeset(%User{} = created_by, %User{} = user, params) do
    %__MODULE__{}
    |> cast(params, @cast_fields)
    |> validate_required(@required_fields)
    |> put_assoc(:created_by, created_by)
    |> put_assoc(:user, user)
  end

  def create(%User{} = created_by, %User{} = user, params) do
    changeset(created_by, user, params)
    |> Repo.insert()
  end

  def get_transaction(id) do
    case Repo.one(__MODULE__ |> where([item], item.id == ^id) |> preload()) do
      %__MODULE__{} = item -> {:ok, item}
      nil -> {:error, :not_found}
    end
  end

  def update(%__MODULE__{} = transaction, params) do
    transaction
    |> cast(params, @cast_fields)
    |> validate_required(@required_fields)
    |> Repo.update()
  end

  def preload(query) do
    query |> preload([branch], [:user])
  end

  def get_transactions(params) do
    query =
      __MODULE__
      |> filter(:id, :eq, params.transaction_id)
      |> filter(:user_id, :eq, params.user_id)
      |> filter(:purpose, :eq, params.purpose)
      |> filter(:type, :eq, params.type)
      |> filter(:created_by_id, :eq, params.created_by_id)
      |> filter(:range, :date, params.from_date, params.to_date)
      |> preload()

    Repo.paginate(query, page: params.page, page_size: params.limit)
  end
end
