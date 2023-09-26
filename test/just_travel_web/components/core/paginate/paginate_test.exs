defmodule JustTravelWeb.Core.PaginateTest do
  use JustTravelWeb.ConnCase
  import Phoenix.LiveViewTest

  test "paginate", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    select = "[data-role=SELECT_PAGE]"

    assert has_element?(view, select)
    assert element(view, select <> ">select>option", "0")
  end
end
