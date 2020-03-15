defmodule Trackr.SchedulingTest do
  use Trackr.DataCase

  alias Trackr.Scheduling

  describe "create_block/1" do
    setup do
      user = insert(:user)

      {:ok, user: user}
    end

    test "successfully creates a new block", %{user: user} do
      params =
        :block
        |> string_params_for()
        |> Map.put("user_id", user.id)

      assert {:ok, block} = Scheduling.create_block(params)

      assert block.name == params["name"]
      assert block.description == params["description"]
      assert block.category == params["category"]
    end

    test "fails when given invalid data" do
      params = %{}

      assert {:error, changeset} = Scheduling.create_block(params)

      assert errors_on(changeset) == %{
               category: ["can't be blank"],
               description: ["can't be blank"],
               name: ["can't be blank"],
               user_id: ["can't be blank"]
             }
    end
  end
end
