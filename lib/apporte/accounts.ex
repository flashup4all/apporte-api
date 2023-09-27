defmodule Apporte.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Apporte.Repo

  alias Apporte.Accounts.{User, UserProfile, Branch, Vehicle}
  alias ApporteWeb.Validators

  def create_user(%Validators.CreateUser{user_profile: user_profile} = params) do
    Repo.transaction(fn ->
      with {:ok, %User{} = user} <-
             User.create_user(Map.from_struct(%{params | email: String.downcase(params.email)})),
           {:ok, %UserProfile{} = _user_profile} <-
             UserProfile.create_user_profile(user, Map.from_struct(user_profile)) do
        Repo.preload(user, [:user_profile])
      else
        {:error, error} ->
          Repo.rollback(error)

        error ->
          error
      end
    end)
  end

  def create_staff(%User{} = user, %Validators.CreateUser{staff_profile: staff_profile} = params) do
    Repo.transaction(fn ->
      with true <- user.role in [:admin, :super_admin, :branch_admin],
           {:ok, %Branch{} = branch} <-
             Branch.get_branch(staff_profile.branch_id),
           {:ok, %User{} = user} <-
             User.create_user(Map.from_struct(%{params | email: String.downcase(params.email)})),
           {:ok, %UserProfile{} = _user_profile} <-
             UserProfile.create_staff_profile(user, branch, Map.from_struct(staff_profile)) do
        Repo.preload(user, user_profile: [:branch])
      else
        false ->
          Repo.rollback(:unauthorized)

        {:error, error} ->
          Repo.rollback(error)

        error ->
          Repo.rollback(error)
      end
    end)
  end

  def update_user_profile(user_id, params) do
    Repo.transaction(fn ->
      with {:ok, %User{} = user} <- User.get_user(user_id),
           {:ok, %UserProfile{} = user_profile} <-
             UserProfile.get_user_profile_by_user_id(user.id),
           {:ok, %UserProfile{} = user_profile} <-
             UserProfile.update(user_profile, params) do
        user_profile
      else
        {:error, error} ->
          Repo.rollback(error)

        error ->
          error
      end
    end)
  end

  def list_staffs(%User{} = user, %Validators.UserProfile{} = params) do
    branch_id = get_user_branch_id(user)
    UserProfile.list_staffs(Map.from_struct(params))
  end

  def get_user_profile(user_profile_id) do
    with {:ok, %UserProfile{} = user_profile} <- UserProfile.get_user_profile(user_profile_id) do
      {:ok, user_profile}
    else
      {:error, error} ->
        {:error, error}

      error ->
        {:error, error}
    end
  end

  def get_user_branch_id(user) do
    case user.role == :branch_admin do
      true ->
        {:ok, user_profile} = UserProfile.get_user_profile_by_user_id(user.id)
        user_profile.branch_id

      _ ->
        nil
    end
  end

  # branches
  def create_branch(%Validators.CreateBranch{} = params, %User{} = user) do
    with {:ok, %Branch{} = branch} <- Branch.create(user, Map.from_struct(params)) do
      {:ok, branch}
    end
  end

  def get_branch(%User{} = user, branch_id) do
    with {:ok, %Branch{} = branch} <- Branch.get_branch(branch_id) do
      {:ok, branch}
    else
      {:error, error} ->
        {:error, error}

      error ->
        {:error, error}
    end
  end

  def get_branches(%User{} = user, %Validators.BranchFilter{} = params) do
    Branch.get_branches(Map.from_struct(params))
  end

  def update_branch(%Validators.CreateBranch{} = params, branch_id) do
    with {:ok, %Branch{} = branch} <- Branch.get_branch(branch_id),
         {:ok, %Branch{} = branch} <- Branch.update(branch, Map.from_struct(params)) do
      {:ok, branch}
    end
  end

  def delete_branch(branch_id) do
    with {:ok, %Branch{} = branch} <- Branch.get_branch(branch_id),
         {:ok, %Branch{} = branch} <- Branch.update(branch, %{deleted_at: DateTime.utc_now()}) do
      {:ok, branch}
    end
  end

  # vehicles
  def create_vehicle(%Validators.Vehicle{branch_id: branch_id} = params, %User{} = user) do
    with {:ok, %Branch{} = branch} <- Branch.get_branch(branch_id),
         {:ok, %Vehicle{} = vehicle} <- Vehicle.create(user, branch, Map.from_struct(params)) do
      {:ok, vehicle}
    end
  end

  def get_vehicle(%User{} = user, vehicle_id) do
    with {:ok, %Vehicle{} = vehicle} <- Vehicle.get_vehicle(vehicle_id) do
      {:ok, vehicle}
    else
      {:error, error} ->
        {:error, error}

      error ->
        {:error, error}
    end
  end

  def get_vehicles(%User{} = user, %Validators.Vehicle{} = params) do
    Vehicle.get_vehicles(Map.from_struct(params))
  end

  def update_vehicle(%Validators.Vehicle{} = params, vehicle_id) do
    with {:ok, %Vehicle{} = vehicle} <- Vehicle.get_vehicle(vehicle_id),
         {:ok, %Vehicle{} = vehicle} <- Vehicle.update(vehicle, Map.from_struct(params)) do
      {:ok, vehicle}
    end
  end

  def delete_vehicle(vehicle_id) do
    with {:ok, %Vehicle{} = vehicle} <- Vehicle.get_vehicle(vehicle_id),
         {:ok, %Vehicle{} = vehicle} <- Vehicle.update(vehicle, %{deleted_at: DateTime.utc_now()}) do
      {:ok, vehicle}
    end
  end
end
