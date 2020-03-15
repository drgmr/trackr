defmodule Trackr.Factory do
  @moduledoc """
  Utilities to generate example data for tests.
  """
  use ExMachina.Ecto,
    repo: Trackr.Repo

  alias Trackr.Accounts.User
  alias Trackr.Scheduling.{Block, DaySchedule, DayRegistry, PastDay, PlannedDay}

  def user_factory do
    %User{
      nickname: sequence(:user_nickname, &"nickname_#{&1}")
    }
  end

  def block_factory do
    %Block{
      name: sequence(:block, &"Block #{&1}"),
      description: sequence(:block, &"This the test block ##{&1}"),
      category: sequence(:block_category, &"category-#{&1}")
    }
  end

  def planned_day_factory do
    weekdays = [
      "sunday",
      "monday",
      "tuesday",
      "wednesday",
      "thursday",
      "friday",
      "saturday"
    ]

    %PlannedDay{
      weekday: sequence(:weekday, &Enum.at(weekdays, rem(&1, length(weekdays)))),
      description: sequence(:weekday, &"Description for #{Enum.at(weekdays, &1)}")
    }
  end

  def day_schedule_factory do
    start_time =
      Time.utc_now()
      |> Time.truncate(:second)

    end_time =
      start_time
      |> Time.add(3000, :second)
      |> Time.truncate(:second)

    %DaySchedule{
      start_time: start_time,
      end_time: end_time
    }
  end

  def past_day_factory do
    %PastDay{
      date: Date.utc_today()
    }
  end

  def day_registry_factory do
    start_time =
      Time.utc_now()
      |> Time.truncate(:second)

    end_time =
      start_time
      |> Time.add(3000, :second)
      |> Time.truncate(:second)

    %DayRegistry{
      start_time: start_time,
      end_time: end_time,
      notes: sequence(:day_registry, &"Notes about Day Registry ##{&1}")
    }
  end
end
