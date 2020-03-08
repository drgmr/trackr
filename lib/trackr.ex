defmodule Trackr do
  @moduledoc """
  A simple personal time planning and tracking tool.
  """

  alias Trackr.Accounts

  defdelegate get_user(id), to: Accounts
end
