defmodule Trackr.Factory do
  @moduledoc """
  Utilities to generate example data for tests.
  """
  use ExMachina.Ecto,
    repo: Trackr.Repo

  alias Trackr.Accounts.User

  def user_factory do
    %User{
      nickname: sequence(:nickname, &"nickname_#{&1}")
    }
  end
end
