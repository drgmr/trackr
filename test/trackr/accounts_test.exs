defmodule Trackr.AccountsTest do
  use Trackr.DataCase

  alias Trackr.Accounts

  describe "get_user/1" do
    test "finds an existing user" do
      user = insert(:user)

      assert {:ok, result} = Accounts.get_user(user.id)

      assert user.id == result.id
      assert user.nickname == result.nickname
    end

    test "fails if user doesn't exist" do
      insert(:user)

      id = Ecto.UUID.generate()

      assert {:error, :not_found} = Accounts.get_user(id)
    end
  end
end
