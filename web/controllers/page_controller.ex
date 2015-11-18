defmodule Haypoll.PageController do
  use Haypoll.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
