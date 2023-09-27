defmodule Apporte.Factory do
  # with Ecto
  @moduledoc false
  use ExMachina.Ecto, repo: Apporte.Repo

  alias ApporteWeb.Validators.{CreateUser, UserProfile}

  def user_factory do
    %Apporte.Accounts.User{
      email: Faker.Internet.email(),
      password: valid_password(),
      user_type: sequence(:user_type, [:business, :user]),
      role: sequence(:user_type, [:rider, :admin, :super_admin, :user, :branch_admin]),
      phone_number: Faker.Phone.EnUs.phone(),
      id: Ecto.UUID.generate()
    }
  end

  def user_profile_factory do
    %Apporte.Accounts.UserProfile{
      first_name: Faker.Person.first_name(),
      last_name: Faker.Person.last_name(),
      gender: sequence(:gender, [:male, :female, :others, :prefer_not_to_say, :non_binary]),
      address: Faker.Address.street_address(),
      state_province_of_origin: Faker.Address.state(),
      country: Faker.Address.country(),
      user: build(:user)
    }
  end

  def valid_password, do: sequence(:password, &"Asimplepassword2-#{&1}")

  # validators
  def user_profile_validator_factory do
    %UserProfile{
      first_name: Faker.Person.first_name(),
      last_name: Faker.Person.last_name(),
      gender: sequence(:gender, [:male, :female, :others, :prefer_not_to_say, :non_binary]),
      address: Faker.Address.street_address(),
      state_province_of_origin: Faker.Address.state()
    }
  end

  def user_validator_factory do
    %CreateUser{
      email: Faker.Internet.email(),
      password: valid_password(),
      user_type: sequence(:user_type, [:business, :user]),
      role: sequence(:user_type, [:rider, :admin, :super_admin, :user, :branch_admin]),
      phone_number: Faker.Phone.EnUs.phone(),
      user_profile: build(:user_profile_validator)
    }
  end
end
