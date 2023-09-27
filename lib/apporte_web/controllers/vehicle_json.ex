defmodule ApporteWeb.VehicleJSON do
  @moduledoc false
  alias Apporte.Accounts.Vehicle
  alias ApporteWeb.UserJSON
  alias ApporteWeb.BranchJSON
  import Apporte.Utils.Helpers

  @doc """
  Renders a list of users.
  """
  def index(%{vehicles: vehicles}) do
    %{
      data: for(vehicle <- vehicles.entries, do: data(vehicle)),
      page_number: vehicles.page_number,
      page_size: vehicles.page_size,
      total_entries: vehicles.total_entries,
      total_pages: vehicles.total_pages
    }
  end

  @doc """
  Renders a list of users.
  """
  def index_assoc(%{vehicles: vehicles}) do
    for(vehicle <- vehicles, do: data(vehicle))
  end

  @doc """
  Renders a single vehicle.
  """
  def show(%{vehicle: vehicle}) do
    %{data: data(vehicle)}
  end

  def data(%Vehicle{} = vehicle) do
    %{
      id: vehicle.id,
      type: vehicle.type,
      name: vehicle.name,
      chassis_no: vehicle.chassis_no,
      plate_no: vehicle.plate_no,
      description: vehicle.description,
      status: vehicle.status,
      is_active: vehicle.is_active,
      user_id: vehicle.user_id,
      branch_id: vehicle.branch_id,
      deleted_at: vehicle.deleted_at,
      user: if(Ecto.assoc_loaded?(vehicle.user), do: UserJSON.data(vehicle.user), else: nil),
      branch:
        if(Ecto.assoc_loaded?(vehicle.branch), do: BranchJSON.data(vehicle.branch), else: nil)
    }
  end
end
