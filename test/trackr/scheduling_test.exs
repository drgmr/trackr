defmodule Trackr.SchedulingTest do
  use Trackr.DataCase

  alias Trackr.Scheduling

  setup do
    user = insert(:user)

    {:ok, user: user}
  end

  describe "create_block/1" do
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

  describe "fetch_blocks/1" do
    test "finds all created blocks", %{user: user} do
      blocks = Enum.map(0..2, fn _ ->
        insert(:block, user: user)
      end)

      assert result = Scheduling.fetch_blocks(user.id)

      ids = Enum.map(result, &Map.get(&1, :id))

      for block <- blocks do
        assert block.id in ids
      end
    end

    test "ignores blocks not belonging to the user", %{user: target_user} do
      other_user = insert(:user)

      target_block = insert(:block, user: target_user)
      _other_block = insert(:block, user: other_user)

      assert [block] = Scheduling.fetch_blocks(target_user.id)

      assert block.id == target_block.id
    end

    test "doesn't fail if there are no blocks", %{user: user} do
      assert [] = Scheduling.fetch_blocks(user.id)
    end
  end
end
