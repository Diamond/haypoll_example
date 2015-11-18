defmodule Haypoll.PollControllerTest do
  use Haypoll.ConnCase

  alias Haypoll.Poll
  @valid_attrs %{closed: true, title: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, poll_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing polls"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, poll_path(conn, :new)
    assert html_response(conn, 200) =~ "New poll"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, poll_path(conn, :create), poll: @valid_attrs
    assert redirected_to(conn) == poll_path(conn, :index)
    assert Repo.get_by(Poll, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, poll_path(conn, :create), poll: @invalid_attrs
    assert html_response(conn, 200) =~ "New poll"
  end

  test "shows chosen resource", %{conn: conn} do
    poll = Repo.insert! %Poll{}
    conn = get conn, poll_path(conn, :show, poll)
    assert html_response(conn, 200) =~ "Show poll"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, poll_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    poll = Repo.insert! %Poll{}
    conn = get conn, poll_path(conn, :edit, poll)
    assert html_response(conn, 200) =~ "Edit poll"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    poll = Repo.insert! %Poll{}
    conn = put conn, poll_path(conn, :update, poll), poll: @valid_attrs
    assert redirected_to(conn) == poll_path(conn, :show, poll)
    assert Repo.get_by(Poll, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    poll = Repo.insert! %Poll{}
    conn = put conn, poll_path(conn, :update, poll), poll: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit poll"
  end

  test "deletes chosen resource", %{conn: conn} do
    poll = Repo.insert! %Poll{}
    conn = delete conn, poll_path(conn, :delete, poll)
    assert redirected_to(conn) == poll_path(conn, :index)
    refute Repo.get(Poll, poll.id)
  end
end
