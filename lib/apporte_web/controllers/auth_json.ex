defmodule ApporteWeb.AuthJSON do
  @moduledoc false

  alias ApporteWeb.UserJSON

  @doc """
  Renders a single user.
  """
  def auth(%{token: token, user: user}) do
    %{
      data: %{
        token: token,
        user: UserJSON.data(user)
      },
      status: "success"
    }
  end
end
