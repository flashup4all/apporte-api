defmodule ApporteWeb.BranchJSON do
  @moduledoc false
  alias Apporte.Accounts.Branch
  alias ApporteWeb.UserJSON
  import Apporte.Utils.Helpers

  @doc """
  Renders a list of users.
  """
  def index(%{branches: branches}) do
    %{
      data: for(branch <- branches.entries, do: data(branch)),
      page_number: branches.page_number,
      page_size: branches.page_size,
      total_entries: branches.total_entries,
      total_pages: branches.total_pages
    }
  end

  @doc """
  Renders a list of users.
  """
  def index_assoc(%{branches: branches}) do
    for(branch <- branches, do: data(branch))
  end

  @doc """
  Renders a single branch.
  """
  def show(%{branch: branch}) do
    %{data: data(branch)}
  end

  def data(%Branch{} = branch) do
    %{
      id: branch.id,
      name: branch.name,
      address: branch.address,
      state: branch.state,
      country: branch.country,
      is_active: branch.is_active,
      deleted_at: branch.deleted_at,
      user: if(Ecto.assoc_loaded?(branch.user), do: UserJSON.data(branch.user), else: nil)
    }
  end
end
