defmodule JustTravelWeb.Core.HeaderTest do
  use JustTravelWeb.ConnCase
  import Phoenix.LiveViewTest

  test "header", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    header = "[data-role=HEADER]"

    assert has_element?(view, header)
    assert element(view, header <> ">div>p>", "Cotação dólar hoje: R$5,53")
    assert element(view, header <> ">div>div>div>button>span", "Entrar")
  end
end
