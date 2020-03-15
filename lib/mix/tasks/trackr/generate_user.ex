defmodule Mix.Tasks.Trackr.GenerateUser do
  @moduledoc """
  Generates a new user and prints their auth token.

  The nickname will be based on the current timestamp. Should be used mainly for development.
  """
  use Mix.Task

  alias Trackr.Accounts
  alias TrackrWeb.Guardian

  @shortdoc "Generates a new user and prints their auth token"

  @impl Mix.Task
  def run(_args) do
    {:ok, _apps} = Application.ensure_all_started(:trackr)

    {:ok, token, _claims} =
      Accounts.create_user()
      |> Guardian.encode_and_sign()

    Mix.shell().info("Authentication data: #{inspect(token)}")
  end
end
