defmodule Apporte.Billings.OrderItem do
  @moduledoc false
  alias Apporte.Repo
  use Apporte.Schema

  import Ecto.Changeset
  import Ecto.Query
  import Apporte.DynamicFilter
  alias Apporte.Billings.Order

  @type t :: %__MODULE__{}

  schema "order_items" do
    field :name, :string
    field :amount, Money.Ecto.Amount.Type
    field :total, Money.Ecto.Amount.Type
    field :description, :string
    field :quantity, :integer
    field :metadata, :map
    field :deleted_at, :utc_datetime

    belongs_to(:order, Order)
    timestamps()
  end

  def fields, do: __MODULE__.__schema__(:fields)

  @required_fields [:name, :quantity]
  @cast_fields [:amount, :total, :description, :metadata, :deleted_at] ++
                 @required_fields

  @doc false
  def changeset(%Order{} = order, params) do
    %__MODULE__{}
    |> cast(params, @cast_fields)
    |> validate_required(@required_fields)
    |> put_assoc(:order, order)
  end

  def create(%Order{} = order, params) do
    changeset(order, params)
    |> Repo.insert()
  end

  def get_order_item(id) do
    case Repo.one(__MODULE__ |> where([item], item.id == ^id) |> preload()) do
      %__MODULE__{} = item -> {:ok, item}
      nil -> {:error, :not_found}
    end
  end

  def update(%__MODULE__{} = order_item, params) do
    order_item
    |> cast(params, @cast_fields)
    |> validate_required(@required_fields)
    |> Repo.update()
  end

  def preload(query) do
    query |> preload([branch], [:user])
  end

  def get_order_items(params) do
    query =
      __MODULE__
      |> filter(:id, :eq, params.order_item_id)
      |> filter(:order_id, :eq, params.order_id)
      |> filter(:range, :date, params.from_date, params.to_date)
      |> preload()

    Repo.paginate(query, page: params.page, page_size: params.limit)
  end
end
