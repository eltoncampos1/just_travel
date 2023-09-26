defmodule JustTravelWeb.PageLive.Components.FilterByLocationTest do
  use JustTravelWeb.ConnCase
  import Phoenix.LiveViewTest

  test "Filter by location", %{conn: conn} do
    location = insert(:location, name: "TOKYO", country: "JAPAN")
    t1 = insert(:ticket, location: location)
    t2 = insert(:ticket, location: location)
    t3 = insert(:ticket)

    {:ok, view, _html} = live(conn, "/")

    filter = "[data-role=FILTER_BY_LOCATION]"
    input_filter = "[data-role=INPUT_FILTER]"

    assert has_element?(view, filter)
    assert element(view, filter <> ">div>span>", "location icon")
    assert element(view, filter <> ">button>span>", "search icon")
    assert has_element?(view, input_filter)

    assert has_element?(view, "#ticket-#{t1.id}")
    assert has_element?(view, "#ticket-#{t2.id}")
    assert has_element?(view, "#ticket-#{t3.id}")

    view
    |> form(filter, %{location: "TOKYO"})
    |> render_submit()

    assert has_element?(view, "#ticket-#{t1.id}")
    assert has_element?(view, "#ticket-#{t2.id}")
    refute has_element?(view, "#ticket-#{t3.id}")

    view
    |> form(filter, %{location: "invalid location"})
    |> render_submit()

    refute has_element?(view, "#ticket-#{t1.id}")
    refute has_element?(view, "#ticket-#{t2.id}")
    refute has_element?(view, "#ticket-#{t3.id}")
  end
end
