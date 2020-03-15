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
      blocks =
        Enum.map(0..2, fn _ ->
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

  describe "create_planned_day/1" do
    test "successfully creates a new planned_day", %{user: user} do
      params =
        :planned_day
        |> string_params_for()
        |> Map.put("user_id", user.id)

      assert {:ok, planned_day} = Scheduling.create_planned_day(params)

      assert planned_day.weekday == params["weekday"]
      assert planned_day.description == params["description"]
    end

    test "fails when given invalid data" do
      params = %{}

      assert {:error, changeset} = Scheduling.create_planned_day(params)

      assert errors_on(changeset) == %{
               weekday: ["can't be blank"],
               description: ["can't be blank"],
               user_id: ["can't be blank"]
             }
    end
  end

  describe "fetch_planned_days/1" do
    test "finds all created planned days", %{user: user} do
      planned_days =
        Enum.map(0..2, fn _ ->
          insert(:planned_day, user: user)
        end)

      assert result = Scheduling.fetch_planned_days(user.id)

      ids = Enum.map(result, &Map.get(&1, :id))

      for planned_day <- planned_days do
        assert planned_day.id in ids
      end
    end

    test "ignores planned days not belonging to the user", %{user: target_user} do
      other_user = insert(:user)

      target_planned_day = insert(:planned_day, user: target_user)
      _other_planned_day = insert(:planned_day, user: other_user)

      assert [planned_day] = Scheduling.fetch_planned_days(target_user.id)

      assert planned_day.id == target_planned_day.id
    end

    test "doesn't fail if there are no planned_days", %{user: user} do
      assert [] = Scheduling.fetch_planned_days(user.id)
    end
  end
end
