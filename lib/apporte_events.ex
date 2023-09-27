defmodule ApporteEvents do
  @moduledoc false

  defdelegate email_service_deliver_email_confirmation(payload),
    to: ApporteEvents.EmailServiceJob,
    as: :deliver_email_verification

  defdelegate email_service_deliver_email_confirmation(payload),
    to: ApporteEvents.EmailServiceJob,
    as: :deliver_updated_password_mail
end
