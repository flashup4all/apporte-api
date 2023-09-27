defmodule ApporteWeb.AuthController do
  use ApporteWeb, :controller
  alias Apporte.Auth

  action_fallback ApporteWeb.FallbackController

  def login(conn, %{"email" => email, "password" => password} = params) do
    with {:ok, %{user: user, token: token}} <- Auth.login(email, password) do
      conn
      |> put_status(200)
      |> render("auth.json", %{
        token: token,
        user: user
      })
    end
  end

  def send_mail(conn, _params) do
    ApporteEvents.email_service_deliver_email_confirmation(%{
      "type" => "deliver_email_verification",
      "payload" => %{
        "email" => "flashup4all@gmail.com"
      }
    })
  end
end
