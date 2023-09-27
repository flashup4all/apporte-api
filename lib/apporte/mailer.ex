defmodule Apporte.Mailer do
  @moduledoc false
  use Bamboo.Mailer, otp_app: :apporte
  # use Mailgun.Client,
  #       domain: Application.compile_env(:apporte, :mailgun_domain),
  #       key: Application.compile_env(:apporte, :mailgun_key)
end
