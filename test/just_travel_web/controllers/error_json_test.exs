defmodule JustTravelWeb.ErrorJSONTest do
  use JustTravelWeb.ConnCase, async: true

  test "renders 404" do
    assert JustTravelWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert JustTravelWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
