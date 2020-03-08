defmodule TrackrWeb.Context do
  @moduledoc """
  Fetches user authentication information from the
  headers and adds it to the Absinthe context.
  """

  @behaviour Plug

  alias TrackrWeb.Guardian

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    context = build_context(conn)

    put_private(conn, :absinthe, %{context: context})
  end

  defp build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, claims} <- Guardian.decode_and_verify(token) do
      %{claims: claims}
    else
      _ ->
        %{}
    end
  end
end
