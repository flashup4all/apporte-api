defmodule Apporte.Accounts.UserProfileTest do
  use Apporte.DataCase

  alias Apporte.Accounts.UserProfile
  alias Apporte.Factory

  describe "fields/0" do
    test "success: fields match" do
      expected_fields = [
        :address,
        :country,
        :dob,
        :first_name,
        :gender,
        :last_name,
        :state_province_of_origin,
        :id,
        :inserted_at,
        :updated_at,
        :user_id
      ]

      assert Enum.sort(expected_fields) == Enum.sort(UserProfile.fields())
    end
  end

  describe "create_user_profile/1" do
    test "success: it inserts a Apport.Accounts.UserProfile record in the db" do
      user = Factory.insert(:user)
      user_profile_params = Factory.params_for(:user_profile)

      assert {:ok, created_user_profile} =
               UserProfile.create_user_profile(user, user_profile_params)

      assert_values_for(
        expected: user_profile_params,
        actual: created_user_profile,
        fields: [:first_name, :last_name, :gender]
      )
    end

    test "error: it returns an error for missing required fields" do
      user = Factory.insert(:user)
      user_profile_params = Factory.params_for(:user_profile)

      user_profile_params = %{user_profile_params | first_name: "", last_name: "", gender: ""}

      assert {:error, %Ecto.Changeset{}} =
               UserProfile.create_user_profile(user, user_profile_params)
    end
  end

  describe "get_user_profile_by_user_id/1" do
    test "success: gets a Apport.Accounts.UserProfile record when given a valid user_id" do
      user = Factory.insert(:user)
      user_profile_params = Factory.params_for(:user_profile)
      assert {:ok, user_profile} = UserProfile.create_user_profile(user, user_profile_params)

      assert {:ok, %UserProfile{} = returned_user_profile} =
               UserProfile.get_user_profile_by_user_id(user.id)

      assert_values_for(
        expected: user_profile,
        actual: returned_user_profile,
        fields: [:first_name, :last_name, :gender, :user_id]
      )

      assert returned_user_profile.user_id == user.id
    end

    test "error: it returns not_found when given a non existent user_id" do
      user = Factory.insert(:user)
      user_profile_params = Factory.params_for(:user_profile)
      assert {:ok, _} = UserProfile.create_user_profile(user, user_profile_params)

      non_existent_user_id = Ecto.UUID.generate()

      assert {:error, :not_found} = UserProfile.get_user_profile_by_user_id(non_existent_user_id)
    end
  end
end
