defmodule Tee.PageControllerTest do
  use Tee.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Go to game lobby"
  end
end
