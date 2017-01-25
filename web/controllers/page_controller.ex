defmodule Tee.PageController do
  use Tee.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
