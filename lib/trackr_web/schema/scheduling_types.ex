defmodule TrackrWeb.Schema.SchedulingTypes do
  @moduledoc """
  Defines all types related to Scheduling operations.
  """
  use Absinthe.Schema.Notation

  alias TrackrWeb.Schema.SchedulingResolvers

  object :scheduling_queries do
    @desc "Lists all blocks belonging to the current user"
    field :blocks, list_of(:block) do
      resolve(&SchedulingResolvers.resolve_blocks/3)
    end

    @desc "Lists all planned days belonging to the current user"
    field :planned_days, list_of(:planned_day) do
      resolve(&SchedulingResolvers.resolve_planned_days/3)
    end

    @desc "Lists all day schedules"
    field :day_schedules, list_of(:day_schedule) do
      resolve(&SchedulingResolvers.resolve_day_schedules/3)
    end

    @desc "Lists all past days belonging to the current user"
    field :past_days, list_of(:past_day) do
      resolve(&SchedulingResolvers.resolve_past_days/3)
    end

    @desc "Lists all day registries"
    field :day_registries, list_of(:day_registry) do
      resolve(&SchedulingResolvers.resolve_day_registries/3)
    end
  end

  object :scheduling_mutations do
    @desc "Creates a new block"
    field :create_block, type: :block do
      arg(:name, non_null(:string))
      arg(:description, non_null(:string))
      arg(:category, non_null(:string))

      resolve(&SchedulingResolvers.create_block/3)
    end

    @desc "Creates a new planned day"
    field :create_planned_day, type: :planned_day do
      arg(:weekday, non_null(:string))
      arg(:description, non_null(:string))

      resolve(&SchedulingResolvers.create_planned_day/3)
    end

    @desc "Creates a new day schedule"
    field :create_day_schedule, type: :day_schedule do
      arg(:start_time, non_null(:time))
      arg(:end_time, non_null(:time))
      arg(:block_id, non_null(:id))
      arg(:planned_day_id, non_null(:id))

      resolve(&SchedulingResolvers.create_day_schedule/3)
    end

    @desc "Updates a day schedule"
    field :update_day_schedule, type: :day_schedule do
      arg(:id, non_null(:id))
      arg(:start_time, :time)
      arg(:end_time, :time)
      arg(:block_id, :id)
      arg(:planned_day_id, :id)

      resolve(&SchedulingResolvers.update_day_schedule/3)
    end

    @desc "Deletes a day schedule"
    field :delete_day_schedule, type: :day_schedule do
      arg(:id, non_null(:id))

      resolve(&SchedulingResolvers.delete_day_schedule/3)
    end

    @desc "Creates a new past day"
    field :create_past_day, type: :past_day do
      arg(:date, non_null(:date))

      resolve(&SchedulingResolvers.create_past_day/3)
    end

    @desc "Creates a new day registry"
    field :create_day_registry, type: :day_registry do
      arg(:start_time, non_null(:time))
      arg(:end_time, non_null(:time))
      arg(:notes, non_null(:string))
      arg(:block_id, non_null(:id))
      arg(:past_day_id, non_null(:id))

      resolve(&SchedulingResolvers.create_day_registry/3)
    end

    @desc "Updates a day registry"
    field :update_day_registry, type: :day_registry do
      arg(:id, non_null(:id))
      arg(:start_time, :time)
      arg(:end_time, :time)
      arg(:notes, :string)
      arg(:block_id, :id)
      arg(:past_day_id, :id)

      resolve(&SchedulingResolvers.update_day_registry/3)
    end

    @desc "Deletes a day registry"
    field :delete_day_registry, type: :day_registry do
      arg(:id, non_null(:id))

      resolve(&SchedulingResolvers.delete_day_registry/3)
    end
  end

  object :block do
    field :id, :id
    field :name, non_null(:string)
    field :description, non_null(:string)
    field :category, non_null(:string)
  end

  object :planned_day do
    field :id, :id
    field :weekday, non_null(:string)
    field :description, non_null(:string)
  end

  object :day_schedule do
    field :id, :id
    field :start_time, non_null(:time)
    field :end_time, non_null(:time)

    field :block, non_null(:block)
    field :planned_day, non_null(:planned_day)
  end

  object :past_day do
    field :id, non_null(:id)
    field :date, non_null(:date)
  end

  object :day_registry do
    field :id, :id
    field :start_time, non_null(:time)
    field :end_time, non_null(:time)
    field :notes, non_null(:string)

    field :block, non_null(:block)
    field :past_day, non_null(:past_day)
  end
end
