defmodule ApporteWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use ApporteWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: ApporteWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(html: ApporteWeb.ErrorHTML, json: ApporteWeb.ErrorJSON)
    |> render(:"404")
  end

  def call(conn, {:error, :not_found, msg}) do
    conn
    |> put_status(:not_found)
    |> put_view(html: ApporteWeb.ErrorHTML, json: ApporteWeb.ErrorJSON)
    |> json(%{
      "msg" => msg
    })
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(html: ApporteWeb.ErrorHTML, json: ApporteWeb.ErrorJSON)
    |> render(:"401")
  end

  def call(conn, {:error, :unauthorized, msg}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(html: ApporteWeb.ErrorHTML, json: ApporteWeb.ErrorJSON)
    |> json(%{
      "msg" => msg
    })
  end

  def call(conn, {:error, :custom, status_code, error_code, message}) do
    conn
    |> put_status(status_code)
    # |> put_view(html: ApporteWeb.ErrorHTML, json: ApporteWeb.ErrorJSON)
    # |> render(:"404")
    |> json(%{
      data: %{},
      error_code: error_code,
      message: message,
      status: "failed"
    })
  end
end
