defmodule ApporteWeb.UserProfileController do
  use ApporteWeb, :controller

  alias Apporte.Accounts
  alias Apporte.Accounts.UserProfile
  alias ApporteWeb.Validators

  action_fallback ApporteWeb.FallbackController

  def index(conn, _params) do
    user_profiles = Accounts.list_user_profiles()
    render(conn, :index, user_profiles: user_profiles)
  end

  def get_staffs(conn, params) do
    user = ApporteWeb.Auth.Guardian.Plug.current_resource(conn, [])

    with {:ok, validated_params} <- Validators.UserProfile.filter_cast_and_validate(params),
         user_profiles <- Accounts.list_staffs(user, validated_params) do
      render(conn, :index, user_profiles: user_profiles)
    end
  end

  def get_customers(conn, params) do
    user = ApporteWeb.Auth.Guardian.Plug.current_resource(conn, [])
    params = Map.put(params, "role", "customer")
    with {:ok, validated_params} <- Validators.UserProfile.filter_cast_and_validate(params),
         user_profiles <- Accounts.list_staffs(user, validated_params) do
      render(conn, :index, user_profiles: user_profiles)
    end
  end

  def create(conn, %{"user_profile" => user_profile_params}) do
    with {:ok, %UserProfile{} = user_profile} <- Accounts.create_user_profile(user_profile_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/user_profiles/#{user_profile}")
      |> render(:show, user_profile: user_profile)
    end
  end

  def show(conn, %{"id" => id}) do
    user = ApporteWeb.Auth.Guardian.Plug.current_resource(conn, [])

    with {:ok, %UserProfile{} = user_profile} <- Accounts.get_user_profile(id) do
      conn
      |> render(:show, user_profile: user_profile)
    end
  end

  def update(conn, %{"id" => user_id, "user_profile" => user_profile_params}) do
    with {:ok, %UserProfile{} = user_profile} <-
           Accounts.update_user_profile(user_id, user_profile_params) do
      render(conn, :show, user_profile: user_profile)
    end
  end
end
