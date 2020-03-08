defmodule TrackrWeb.ErrorViewTest do
  use TrackrWeb.ConnCase, async: true

  import Phoenix.View, only: [render: 3]

  test "renders 404.json" do
    assert render(TrackrWeb.ErrorView, "404.json", []) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500.json" do
    assert render(TrackrWeb.ErrorView, "500.json", []) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
