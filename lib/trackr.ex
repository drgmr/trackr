defmodule Trackr do
  @moduledoc """
  A simple personal time planning and tracking tool.
  """

  alias Trackr.{Accounts, Scheduling}

  defdelegate get_user(id), to: Accounts

  defdelegate create_block(params), to: Scheduling
end
