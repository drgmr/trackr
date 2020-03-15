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
end
