defmodule Apporte.Billings.Transaction do
  @moduledoc false
  alias Apporte.Repo
  use Apporte.Schema

  import Ecto.Changeset
  import Ecto.Query
  import Apporte.DynamicFilter
  alias Apporte.Accounts.User

  @type t :: %__MODULE__{}

  schema "transactions" do
    field :amount, Money.Ecto.Amount.Type
    field :currency, :string, default: "NGN"
    field :provider, :string
    field :gateway_ref, :string
    field :status, Ecto.Enum, values: [:in_progress, :successful, :failed]
    field :type, Ecto.Enum, values: [:credit, :debit]
    field :purpose, Ecto.Enum, values: [:web, :admin_web]
    field :channel, Ecto.Enum, values: [:cash, :bank_transfer, :pos]
    field :metadata, :map
    field :fee, :integer
    field :gateway_fee, :integer
    field :gateway_context, :map

    belongs_to(:user, User)
    belongs_to(:inserted_by, User)
    timestamps()
  end

  def fields, do: __MODULE__.__schema__(:fields)

  @required_fields [:amount, :type, :purpose, :channel]
  @cast_fields [:currency, :provider, :gateway_ref, :status,:metadata, :fee, :gateway_fee, :gateway_context] ++
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
