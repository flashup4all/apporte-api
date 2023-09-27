defmodule Apporte.Billings.Order do
  @moduledoc false
  alias Apporte.Repo
  use Apporte.Schema

  import Ecto.Changeset
  import Ecto.Query
  import Apporte.DynamicFilter
  alias Apporte.Accounts.User

  @type t :: %__MODULE__{}

  schema "orders" do
    field :reference, :string
    field :total_insurance_fee, Money.Ecto.Amount.Type
    field :total_vat, Money.Ecto.Amount.Type
    field :total_delivery_fee, Money.Ecto.Amount.Type
    field :sub_total, Money.Ecto.Amount.Type
    field :total, Money.Ecto.Amount.Type
    field :discount_amount, Money.Ecto.Amount.Type
    field :discount_percent, :integer
    field :pickup_contact_name, :string
    field :pickup_contact_phone_no, :string
    field :pickup_contact_email, :string
    field :pickup_address, :string
    field :pickup_state, :string
    field :pickup_country, :string, default: "NGN"
    field :delivery_contact_name, :string
    field :delivery_contact_phone_no, :string
    field :delivery_contact_email, :string
    field :delivery_address, :string
    field :delivery_state, :string
    field :delivery_country, :string, default: "NGN"
    field :channel, Ecto.Enum, values: [:web, :admin_web]
    field :is_office_pickup, :boolean, default: false
    field :metadata, :map
    field :deleted_at, :utc_datetime

    belongs_to(:user, User)
    belongs_to(:rider, User)
    timestamps()
  end

  def fields, do: __MODULE__.__schema__(:fields)

  @required_fields [
    :pickup_contact_name,
    :pickup_contact_phone_no,
    :pickup_contact_email,
    :delivery_contact_name,
    :delivery_contact_phone_no,
    :delivery_contact_email,
    :delivery_address,
    :delivery_state,
    :delivery_country,
    :is_office_pickup,
    :channel
  ]
  @cast_fields [
    :reference,
    :total_insurance_fee,
    :total_vat,
    :total_delivery_fee,
    :sub_total,
    :total,
    :discount_amount,
    :discount_percent,
    :metadata,
    :deleted_at
  ] ++
                 @required_fields

  @doc false
  def changeset(%User{} = user, %User{} = rider, params) do
    %__MODULE__{}
    |> cast(params, @cast_fields)
    |> validate_required(@required_fields)
    |> put_assoc(:user, user)
    |> put_assoc(:rider, rider)
  end

  def create(%User{} = user, %User{} = rider, params) do
    changeset(user, rider, params)
    |> Repo.insert()
  end

  def get_order(id) do
    case Repo.one(__MODULE__ |> where([order], order.id == ^id) |> preload()) do
      %__MODULE__{} = order -> {:ok, order}
      nil -> {:error, :not_found}
    end
  end

  def update(%__MODULE__{} = order, params) do
    order
    |> cast(params, @cast_fields)
    |> validate_required(@required_fields)
    |> Repo.update()
  end

  def preload(query) do
    query |> preload([branch], [:user])
  end

  def get_orderss(params) do
    query =
      __MODULE__
      |> filter(:id, :eq, params.order_id)
      |> filter(:user_id, :eq, params.user_id)
      |> filter(:rider_id, :eq, params.rider_id)
      |> filter(:range, :date, params.from_date, params.to_date)
      |> preload()

    Repo.paginate(query, page: params.page, page_size: params.limit)
  end
end
