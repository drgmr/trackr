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

  describe "create_day_schedule/1" do
    setup :create_block
    setup :create_planned_day

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

  describe "update_day_schedule/3" do
    setup :create_block
    setup :create_planned_day

    test "properly updates a day schedule", %{user: user, block: block, planned_day: planned_day} do
      target_start_time = ~T[15:00:00]
      params = %{"start_time" => Time.to_iso8601(target_start_time)}

      day_schedule =
        insert(:day_schedule, start_time: ~T[12:00:00], block: block, planned_day: planned_day)

      assert {:ok, new_day_schedule} =
               Scheduling.update_day_schedule(user.id, day_schedule.id, params)

      assert new_day_schedule.id == day_schedule.id
      assert new_day_schedule.start_time == target_start_time
    end

    test "doesn't change day schedules not belonging to the user", %{user: target_user} do
      tentative_start_time = ~T[11:00:00]
      params = %{"start_time" => Time.to_iso8601(tentative_start_time)}

      other_user = insert(:user)
      other_block = insert(:block, user: other_user)
      other_planned_day = insert(:planned_day, user: other_user)

      other_day_schedule =
        insert(:day_schedule, block: other_block, planned_day: other_planned_day)

      assert {:error, :not_found} =
               Scheduling.update_day_schedule(target_user.id, other_day_schedule.id, params)
    end

    test "fails if day schedule doesn't exist", %{user: user} do
      assert {:error, :not_found} =
               Scheduling.update_day_schedule(user.id, Ecto.UUID.generate(), %{})
    end

    test "fails if given invalid params" do
      assert {:error, :not_found} =
               Scheduling.update_day_schedule(Ecto.UUID.generate(), Ecto.UUID.generate(), nil)
    end
  end

  describe "delete_day_schedule/2" do
    setup :create_block
    setup :create_planned_day

    test "properly deletes a day schedule", %{user: user, block: block, planned_day: planned_day} do
      day_schedule = insert(:day_schedule, block: block, planned_day: planned_day)

      assert {:ok, _day_schedule} = Scheduling.delete_day_schedule(user.id, day_schedule.id)

      assert Enum.empty?(Scheduling.fetch_day_schedules(user.id))
    end

    test "fails if it doesn't exist", %{user: user} do
      assert {:error, :not_found} = Scheduling.delete_day_schedule(user.id, Ecto.UUID.generate())
    end

    test "fails if it doesn't belong to the user", %{user: target_user} do
      other_user = insert(:user)
      other_block = insert(:block, user: other_user)
      other_planned_day = insert(:planned_day, user: other_user)

      other_day_schedule =
        insert(:day_schedule, block: other_block, planned_day: other_planned_day)

      assert {:error, :not_found} =
               Scheduling.delete_day_schedule(target_user.id, other_day_schedule.id)
    end
  end

  describe "fetch_day_schedules/1" do
    setup :create_block
    setup :create_planned_day

    test "finds all created day schedules", %{user: user, block: block, planned_day: planned_day} do
      day_schedules =
        Enum.map(0..2, fn _ ->
          insert(:day_schedule, block: block, planned_day: planned_day)
        end)

      assert result = Scheduling.fetch_day_schedules(user.id)

      ids = Enum.map(result, &Map.get(&1, :id))

      for day_schedule <- day_schedules do
        assert day_schedule.id in ids
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

      target_day_schedule =
        insert(:day_schedule, block: target_block, planned_day: target_planned_day)

      _other_day_schedule =
        insert(:day_schedule, block: other_block, planned_day: other_planned_day)

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

  describe "create_day_registry/1" do
    setup :create_block
    setup :create_past_day

    test "successfully creates a new day registry", %{
      block: block,
      past_day: past_day
    } do
      params =
        :day_registry
        |> params_for()
        |> Map.put(:block_id, block.id)
        |> Map.put(:past_day_id, past_day.id)

      assert {:ok, day_registry} = Scheduling.create_day_registry(params)

      assert day_registry.start_time == params.start_time
      assert day_registry.end_time == params.end_time
    end

    test "fails when given invalid data" do
      params = %{}

      assert {:error, changeset} = Scheduling.create_day_registry(params)

      assert errors_on(changeset) == %{
               start_time: ["can't be blank"],
               end_time: ["can't be blank"],
               notes: ["can't be blank"],
               block_id: ["can't be blank"],
               past_day_id: ["can't be blank"]
             }
    end
  end

  describe "fetch_day_registries/1" do
    setup :create_block
    setup :create_past_day

    test "finds all created day registries", %{user: user, block: block, past_day: past_day} do
      day_registries =
        Enum.map(0..2, fn _ ->
          insert(:day_registry, block: block, past_day: past_day)
        end)

      assert result = Scheduling.fetch_day_registries(user.id)

      ids = Enum.map(result, &Map.get(&1, :id))

      for day_registry <- day_registries do
        assert day_registry.id in ids
      end
    end

    test "ignores day registries not belonging to the user", %{
      user: target_user,
      block: target_block,
      past_day: target_past_day
    } do
      other_user = insert(:user)
      other_block = insert(:block, user: other_user)
      other_past_day = insert(:past_day, user: other_user)

      target_day_registry = insert(:day_registry, block: target_block, past_day: target_past_day)

      _other_day_registry = insert(:day_registry, block: other_block, past_day: other_past_day)

      assert [day_registry] = Scheduling.fetch_day_registries(target_user.id)

      assert day_registry.id == target_day_registry.id
    end

    test "doesn't fail if there are no day registries", %{user: user} do
      assert [] = Scheduling.fetch_day_registries(user.id)
    end
  end

  for item <- [:block, :past_day, :planned_day] do
    defp unquote(:"create_#{item}")(%{user: user}) do
      subject = insert(unquote(item), user: user)

      {:ok, [{unquote(item), subject}]}
    end
  end
end
