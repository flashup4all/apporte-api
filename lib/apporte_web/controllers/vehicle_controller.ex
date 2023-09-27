defmodule ApporteWeb.VehicleController do
  use ApporteWeb, :controller

  alias Apporte.Accounts
  alias Apporte.Accounts.Vehicle
  alias ApporteWeb.Validators

  action_fallback ApporteWeb.FallbackController

  def index(conn, params) do
    user = ApporteWeb.Auth.Guardian.Plug.current_resource(conn, [])

    with {:ok, validated_params} <- Validators.Vehicle.cast_and_validate_filter(params),
         vehicles <- Accounts.get_vehicles(user, validated_params) do
      conn
      |> render(:index, vehicles: vehicles)
    end
  end

  def create(conn, params) do
    user = ApporteWeb.Auth.Guardian.Plug.current_resource(conn, [])

    with {:ok, validated_params} <- Validators.Vehicle.cast_and_validate(params),
         {:ok, %Vehicle{} = vehicle} <- Accounts.create_vehicle(validated_params, user) do
      conn
      |> put_status(:created)
      |> render(:show, vehicle: vehicle)
    end
  end

  def show(conn, %{"id" => id}) do
    user = ApporteWeb.Auth.Guardian.Plug.current_resource(conn, [])

    with {:ok, %Vehicle{} = vehicle} <- Accounts.get_vehicle(user, id) do
      conn
      |> render(:show, vehicle: vehicle)
    end
  end

  def update(conn, %{"id" => vehicle_id} = params) do
    IO.inspect(params)

    with {:ok, validated_params} <-
           Validators.Vehicle.cast_and_validate_update(params) |> IO.inspect(),
         {:ok, %Vehicle{} = vehicle} <- Accounts.update_vehicle(validated_params, vehicle_id) do
      render(conn, :show, vehicle: vehicle)
    end
  end

  def delete(conn, %{"id" => vehicle_id}) do
    with {:ok, %Vehicle{} = vehicle} <- Accounts.delete_vehicle(vehicle_id) do
      send_resp(conn, :no_content, "")
    end
  end
end
