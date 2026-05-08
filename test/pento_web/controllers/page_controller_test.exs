defmodule PentoWeb.PageControllerTest do
  use PentoWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert redirected_to(conn) == ~p"/guess"
  end
end
