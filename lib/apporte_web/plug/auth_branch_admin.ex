defmodule ApporteWeb.Plug.BranchAdminAccessPipeline do
  @moduledoc false

  import Plug.Conn

  def init(options), do: options

  def call(conn, _opts) do
    user = ApporteWeb.Auth.Guardian.Plug.current_resource(conn, [])

    case user.role in [:admin, :super_admin, :branch_admin] do
      true ->
        conn

      _ ->
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(200, "Unauthorized!\n")
    end
  end
end
