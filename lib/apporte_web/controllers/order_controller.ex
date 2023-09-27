defmodule ApporteWeb.OrderController do
  use ApporteWeb, :controller

  alias Apporte.Billings
  alias Apporte.Billings.{Order}
  alias ApporteWeb.Validators.{CreateOrder}

  action_fallback ApporteWeb.FallbackController

  # def index(conn, params) do
  #   user = ApporteWeb.Auth.Guardian.Plug.current_resource(conn, [])

  #   with {:ok, validated_params} <- BranchFilter.cast_and_validate(params),
  #        branches <- Accounts.get_branches(user, validated_params) do
  #     conn
  #     |> render(:index, branches: branches)
  #   end
  # end

  def create(conn, params) do
    user = ApporteWeb.Auth.Guardian.Plug.current_resource(conn, [])

    with {:ok, validated_params} <- CreateOrder.cast_and_validate(params),
         {:ok, %Order{} = order} <- Billings.create_order(user, validated_params) do
      conn
      |> put_status(:created)
      |> render(:show, order: order)
    end
  end

  # def show(conn, %{"id" => id}) do
  #   user = ApporteWeb.Auth.Guardian.Plug.current_resource(conn, [])

  #   with {:ok, %Branch{} = branch} <- Accounts.get_branch(user, id) do
  #     conn
  #     |> render(:show, branch: branch)
  #   end
  # end

  # def update(conn, %{"id" => branch_id} = params) do
  #   with {:ok, validated_params} <- CreateBranch.cast_and_validate(params),
  #        {:ok, %Branch{} = branch} <- Accounts.update_branch(validated_params, branch_id) do
  #     render(conn, :show, branch: branch)
  #   end
  # end

  # def delete(conn, %{"id" => branch_id}) do
  #   with {:ok, %Branch{} = branch} <- Accounts.delete_branch(branch_id) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
