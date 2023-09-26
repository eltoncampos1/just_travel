defmodule JustTravelWeb.Core.PaginateTest do
  use JustTravelWeb.ConnCase
  import Phoenix.LiveViewTest

  test "paginate", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    paginate = "[data-role=PAGINATE]"

    open_browser(view)
    assert has_element?(view, paginate)
    assert has_element?(view, "[data-role=PREV]")
    assert has_element?(view, "[data-role=NEXT]")
  end
end
