defmodule Trackr do
  @moduledoc """
  A simple personal time planning and tracking tool.
  """

  alias Trackr.{Accounts, Scheduling}

  defdelegate get_user(id), to: Accounts

  @spec create_block(%{optional(:__struct__) => none, optional(atom | binary) => any}) ::
          {:error, Ecto.Changeset.t()} | {:ok, any}
  defdelegate create_block(params), to: Scheduling
  defdelegate create_planned_day(params), to: Scheduling
  defdelegate create_day_schedule(params), to: Scheduling
  defdelegate create_past_day(params), to: Scheduling
  defdelegate create_day_registry(params), to: Scheduling

  defdelegate fetch_blocks(user_id), to: Scheduling
  defdelegate fetch_planned_days(user_id), to: Scheduling
  defdelegate fetch_day_schedules(user_id), to: Scheduling
  defdelegate fetch_past_days(user_id), to: Scheduling
  defdelegate fetch_day_registries(user_id), to: Scheduling
end
