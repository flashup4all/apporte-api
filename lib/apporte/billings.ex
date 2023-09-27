defmodule Apporte.Billings do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Apporte.Repo

  alias Apporte.Billings.{Order, OrderItem}
  alias ApporteWeb.Validators

  def create_subscription(user, %Validators.CreateOrder{} = params) do
    IO.inspect params
    # Repo.transaction(fn ->
    #   with {:ok, %User{} = user} <-
    #          User.create_user(Map.from_struct(%{params | email: String.downcase(params.email)})),
    #        {:ok, %UserProfile{} = _user_profile} <-
    #          UserProfile.create_user_profile(user, Map.from_struct(user_profile)) do
    #     Repo.preload(user, [:user_profile])
    #   else
    #     {:error, error} ->
    #       Repo.rollback(error)

    #     error ->
    #       error
    #   end
    # end)
  end

  def create_order(user, %Validators.CreateOrder{} = params) do
    IO.inspect params
    # Repo.transaction(fn ->
    #   with {:ok, %User{} = user} <-
    #          User.create_user(Map.from_struct(%{params | email: String.downcase(params.email)})),
    #        {:ok, %UserProfile{} = _user_profile} <-
    #          UserProfile.create_user_profile(user, Map.from_struct(user_profile)) do
    #     Repo.preload(user, [:user_profile])
    #   else
    #     {:error, error} ->
    #       Repo.rollback(error)

    #     error ->
    #       error
    #   end
    # end)
  end
end
