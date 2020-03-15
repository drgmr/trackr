defmodule Trackr.Factory do
  @moduledoc """
  Utilities to generate example data for tests.
  """
  use ExMachina.Ecto,
    repo: Trackr.Repo

  alias Trackr.Accounts.User
  alias Trackr.Scheduling.Block

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
end
