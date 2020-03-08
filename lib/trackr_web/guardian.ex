defmodule TrackrWeb.Guardian do
  @moduledoc """
  Guardian callbacks implementation to handle JWTs.
  """
  use Guardian, otp_app: :trackr

  def subject_for_token(resource, _claims) do
    {:ok, resource.id}
  end

  def resource_from_claims(%{"sub" => id} = _claims) do
    with {:ok, resource} <- Trackr.get_user(id) do
      {:ok, resource}
    end
  end
end
