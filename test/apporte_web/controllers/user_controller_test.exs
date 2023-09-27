defmodule ApporteWeb.UserControllerTest do
  use ApporteWeb.ConnCase

  alias ApporteWeb.Auth.Guardian
  alias Apporte.Factory

  #   import Apporte.AccountsFixtures

  #   alias Apporte.Accounts.User

  #   @create_attrs %{
  #     bvn: "some bvn",
  #     deleted_at: ~N[2023-03-16 11:31:00],
  #     email: "some email",
  #     is_active: true,
  #     is_bvn_verified: true,
  #     is_email_verified: true,
  #     is_phone_number_verified: true,
  #     metadata: %{},
  #     password_hash: "some password_hash",
  #     phone_number: "some phone_number",
  #     role: "some role",
  #     user_type: "some user_type"
  #   }
  #   @update_attrs %{
  #     bvn: "some updated bvn",
  #     deleted_at: ~N[2023-03-17 11:31:00],
  #     email: "some updated email",
  #     is_active: false,
  #     is_bvn_verified: false,
  #     is_email_verified: false,
  #     is_phone_number_verified: false,
  #     metadata: %{},
  #     password_hash: "some updated password_hash",
  #     phone_number: "some updated phone_number",
  #     role: "some updated role",
  #     user_type: "some updated user_type"
  #   }
  #   @invalid_attrs %{bvn: nil, deleted_at: nil, email: nil, is_active: nil, is_bvn_verified: nil, is_email_verified: nil, is_phone_number_verified: nil, metadata: nil, password_hash: nil, phone_number: nil, role: nil, user_type: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup %{conn: conn} do
    user = Factory.insert(:user)
    profile = Factory.insert(:user_profile, user: user)

    {:ok, token, _claims} = Guardian.encode_and_sign(user, token_type: "refresh")

    conn_with_token =
      conn
      |> put_req_header("authorization", "Bearer " <> token)

    {:ok, conn_with_token: conn_with_token, user: user}
  end

  #   describe "index" do
  #     test "lists all users", %{conn: conn} do
  #       conn = get(conn, ~p"/api/v1/users")
  #       assert json_response(conn, 200)["data"] == []
  #     end
  #   end

  describe "register/2" do
    test "renders user when data is valid", %{conn: conn, user: user} do
      params = Factory.string_params_for(:user_validator)

      assert response =
               post(conn, ~p"/api/v1/onboarding/register", params)
               |> json_response(201)
    end

    test "error: renders user when data is invalid", %{conn: conn, user: user} do
      params = Factory.string_params_for(:user_validator)
      params = %{params | "email" => ""}

      assert response =
               post(conn, ~p"/api/v1/onboarding/register", params)
               |> json_response(422)
    end
  end

  #   describe "update user" do
  #     setup [:create_user]

  #     test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
  #       conn = put(conn, ~p"/api/v1/users/#{user}", user: @update_attrs)
  #       assert %{"id" => ^id} = json_response(conn, 200)["data"]

  #       conn = get(conn, ~p"/api/v1/users/#{id}")

  #       assert %{
  #                "id" => ^id,
  #                "bvn" => "some updated bvn",
  #                "deleted_at" => "2023-03-17T11:31:00",
  #                "email" => "some updated email",
  #                "is_active" => false,
  #                "is_bvn_verified" => false,
  #                "is_email_verified" => false,
  #                "is_phone_number_verified" => false,
  #                "metadata" => %{},
  #                "password_hash" => "some updated password_hash",
  #                "phone_number" => "some updated phone_number",
  #                "role" => "some updated role",
  #                "user_type" => "some updated user_type"
  #              } = json_response(conn, 200)["data"]
  #     end

  #     test "renders errors when data is invalid", %{conn: conn, user: user} do
  #       conn = put(conn, ~p"/api/v1/users/#{user}", user: @invalid_attrs)
  #       assert json_response(conn, 422)["errors"] != %{}
  #     end
  #   end

  #   describe "delete user" do
  #     setup [:create_user]

  #     test "deletes chosen user", %{conn: conn, user: user} do
  #       conn = delete(conn, ~p"/api/v1/users/#{user}")
  #       assert response(conn, 204)

  #       assert_error_sent 404, fn ->
  #         get(conn, ~p"/api/v1/users/#{user}")
  #       end
  #     end
  #   end

  #   defp create_user(_) do
  #     user = user_fixture()
  #     %{user: user}
  #   end
end
