defmodule Haypoll.PollController do
  use Haypoll.Web, :controller

  alias Haypoll.Poll

  plug :scrub_params, "poll" when action in [:create, :update]

  def index(conn, _params) do
    polls = Repo.all(Poll)
    render(conn, "index.html", polls: polls)
  end

  def new(conn, _params) do
    changeset = Poll.changeset(%Poll{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"poll" => poll_params}) do
    changeset = Poll.changeset(%Poll{}, poll_params)

    case Repo.insert(changeset) do
      {:ok, _poll} ->
        conn
        |> put_flash(:info, "Poll created successfully.")
        |> redirect(to: poll_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    poll = Repo.get!(Poll, id)
    render(conn, "show.html", poll: poll)
  end

  def edit(conn, %{"id" => id}) do
    poll = Repo.get!(Poll, id)
    changeset = Poll.changeset(poll)
    render(conn, "edit.html", poll: poll, changeset: changeset)
  end

  def update(conn, %{"id" => id, "poll" => poll_params}) do
    poll = Repo.get!(Poll, id)
    changeset = Poll.changeset(poll, poll_params)

    case Repo.update(changeset) do
      {:ok, poll} ->
        conn
        |> put_flash(:info, "Poll updated successfully.")
        |> redirect(to: poll_path(conn, :show, poll))
      {:error, changeset} ->
        render(conn, "edit.html", poll: poll, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    poll = Repo.get!(Poll, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(poll)

    conn
    |> put_flash(:info, "Poll deleted successfully.")
    |> redirect(to: poll_path(conn, :index))
  end
end
