defmodule ApporteWeb.Plug.AuthAccessPipeline do
  @moduledoc false
  use Guardian.Plug.Pipeline, otp_app: :apporte

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true
end
