defmodule Apporte.Utils.Helpers do
  def load_association(response, data) do
    if Ecto.assoc_loaded?(data), do: true, else: false
  end
end
