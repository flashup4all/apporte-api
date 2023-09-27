defmodule ApporteWeb.UserProfileJSON do
  @moduledoc false
  alias ApporteWeb.BranchJSON
  alias ApporteWeb.UserJSON
  alias Apporte.Accounts.UserProfile

  @doc """
  Renders a list of user_profiles.
  """
  def index(%{user_profiles: user_profiles}) do
    # IO.inspect user_profiles.entries

    %{
      data: for(user_profile <- user_profiles.entries, do: data(user_profile)),
      page_number: user_profiles.page_number,
      page_size: user_profiles.page_size,
      total_entries: user_profiles.total_entries,
      total_pages: user_profiles.total_pages
    }
  end

  def index_assoc(%{user_profiles: user_profiles}) do
    %{data: for(user_profile <- user_profiles, do: data(user_profile))}
  end

  @doc """
  Renders a single user_profile.
  """
  def show(%{user_profile: user_profile}) do
    %{data: data(user_profile)}
  end

  def data(%UserProfile{} = user_profile) do
    IO.inspect(user_profile)

    %{
      id: user_profile.id,
      first_name: user_profile.first_name,
      last_name: user_profile.last_name,
      dob: user_profile.dob,
      gender: user_profile.gender,
      state_province_of_origin: user_profile.state_province_of_origin,
      address: user_profile.address,
      country: user_profile.country,
      metadata: user_profile.metadata,
      branch_id: user_profile.branch_id,
      branch:
        if(!is_nil(user_profile.branch_id) && Ecto.assoc_loaded?(user_profile.branch),
          do: BranchJSON.data(user_profile.branch),
          else: nil
        ),
      user:
        if(Ecto.assoc_loaded?(user_profile.user), do: UserJSON.data(user_profile.user), else: nil)
    }
  end
end
