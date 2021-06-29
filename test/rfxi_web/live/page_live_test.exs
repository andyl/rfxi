defmodule RfxiWeb.PageLiveTest do
  use RfxiWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Content TBD"
    assert render(page_live) =~ "Content TBD"
  end
end
