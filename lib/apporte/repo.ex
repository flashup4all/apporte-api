defmodule Apporte.Repo do
  use Ecto.Repo,
    otp_app: :apporte,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: Application.compile_env!(:apporte, :default_pagination)
end
