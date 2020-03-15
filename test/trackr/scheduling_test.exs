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
    test "successfully creates a new planned day", %{user: user} do
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

    test "doesn't fail if there are no planned days", %{user: user} do
      assert [] = Scheduling.fetch_planned_days(user.id)
    end
  end

  defp create_block_and_planned_day(%{user: user}) do
    block = insert(:block, user: user)
    planned_day = insert(:planned_day, user: user)

    {:ok, block: block, planned_day: planned_day}
  end

  describe "create_day_schedule/1" do
    setup :create_block_and_planned_day

    test "successfully creates a new day schedule", %{
      block: block,
      planned_day: planned_day
    } do
      params =
        :day_schedule
        |> params_for()
        |> Map.put(:block_id, block.id)
        |> Map.put(:planned_day_id, planned_day.id)

      assert {:ok, day_schedule} = Scheduling.create_day_schedule(params)

      assert day_schedule.start_time == params.start_time
      assert day_schedule.end_time == params.end_time
    end

    test "fails when given invalid data" do
      params = %{}

      assert {:error, changeset} = Scheduling.create_day_schedule(params)

      assert errors_on(changeset) == %{
               start_time: ["can't be blank"],
               end_time: ["can't be blank"],
               block_id: ["can't be blank"],
               planned_day_id: ["can't be blank"]
             }
    end
  end

  describe "fetch_day_schedules/1" do
    setup :create_block_and_planned_day

    test "finds all created day schedules", %{user: user, block: block, planned_day: planned_day} do
      planned_days =
        Enum.map(0..2, fn _ ->
          insert(:day_schedule, block: block, planned_day: planned_day)
        end)

      assert result = Scheduling.fetch_day_schedules(user.id)

      ids = Enum.map(result, &Map.get(&1, :id))

      for planned_day <- planned_days do
        assert planned_day.id in ids
      end
    end

    test "ignores day schedules not belonging to the user", %{
      user: target_user,
      block: target_block,
      planned_day: target_planned_day
    } do
      other_user = insert(:user)
      other_block = insert(:block, user: other_user)
      other_planned_day = insert(:planned_day, user: other_user)

      target_day_schedule = insert(:day_schedule, block: target_block, planned_day: target_planned_day)
      _other_day_schedule = insert(:day_schedule, block: other_block, planned_day: other_planned_day)

      assert [day_schedule] = Scheduling.fetch_day_schedules(target_user.id)

      assert day_schedule.id == target_day_schedule.id
    end

    test "doesn't fail if there are no day schedules", %{user: user} do
      assert [] = Scheduling.fetch_day_schedules(user.id)
    end
  end

  describe "create_past_day/1" do
    test "successfully creates a new past day", %{user: user} do
      params =
        :past_day
        |> params_for()
        |> Map.put(:user_id, user.id)

      assert {:ok, past_day} = Scheduling.create_past_day(params)

      assert past_day.date == params.date
    end

    test "fails when given invalid data" do
      params = %{}

      assert {:error, changeset} = Scheduling.create_past_day(params)

      assert errors_on(changeset) == %{
               date: ["can't be blank"],
               user_id: ["can't be blank"]
             }
    end
  end

  describe "fetch_past_days/1" do
    test "finds all created past days", %{user: user} do
      past_days =
        Enum.map(0..2, fn _ ->
          insert(:past_day, user: user)
        end)

      assert result = Scheduling.fetch_past_days(user.id)

      ids = Enum.map(result, &Map.get(&1, :id))

      for past_day <- past_days do
        assert past_day.id in ids
      end
    end

    test "ignores past days not belonging to the user", %{user: target_user} do
      other_user = insert(:user)

      target_past_day = insert(:past_day, user: target_user)
      _other_past_day = insert(:past_day, user: other_user)

      assert [past_day] = Scheduling.fetch_past_days(target_user.id)

      assert past_day.id == target_past_day.id
    end

    test "doesn't fail if there are no past days", %{user: user} do
      assert [] = Scheduling.fetch_past_days(user.id)
    end
  end
end
