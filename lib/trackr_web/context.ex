defmodule TrackrWeb.Context do
  @moduledoc """
  Fetches user authentication information from the
  headers and adds it to the Absinthe context.
  """

  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    context = build_context(conn)

    put_private(conn, :absinthe, %{context: context})
  end

  # TODO: Actually authorize users
  defp build_context(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        %{current_token: token}

      _ ->
        %{}
    end
  end
end
