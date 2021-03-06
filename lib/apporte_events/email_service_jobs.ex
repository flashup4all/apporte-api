defmodule ApporteEvents.EmailServiceJob do
  @moduledoc false
  use Oban.Worker, max_attempts: 2

  alias Apporte.EmailService
  require Logger

  @valid_type [
    "deliver_email_verification",
    "deliver_updated_password_mail"
  ]

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"type" => type, "payload" => payload}})
      when type in @valid_type do
    do_perform(String.to_atom(type), payload)
  end

  def deliver_email_verification(user_payload) do
    user_payload
    |> new(priority: 2)
    |> Oban.insert()
  end

  def deliver_updated_password_mail(payload) do
    payload
    |> new(priority: 2)
    |> Oban.insert()
  end

  # def deliver_welcome_message(user_payload) do
  #   user_payload
  #   |> new(priority: 2)
  #   |> Oban.insert()
  # end

  # def deliver_forgot_password_url(user_payload) do
  #   user_payload
  #   |> new(priority: 2)
  #   |> Oban.insert()
  # end

  defp do_perform(:deliver_email_verification, user) do
    :ok = Logger.info("begin processing deliver_email_verification job")
    _ = EmailService.deliver_email_verification(user)
  end

  defp do_perform(:deliver_updated_password_mail, payload) do
    :ok = Logger.info("begin processing deliver_updated_password_mail job")
    _ = EmailService.deliver_updated_password_mail(payload)
  end

  # defp do_perform(:deliver_welcome_message, user) do
  #   :ok = Logger.info("begin processing deliver_welcome_message job")
  #   _ = EmailService.deliver_welcome_message(user)
  # end

  # defp do_perform(:deliver_forgot_password_url, user) do
  #   :ok = Logger.info("begin processing deliver_forgot_password_url job")
  #   _ = EmailService.deliver_forgot_password_url(user)
  # end
end
