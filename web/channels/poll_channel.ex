defmodule Haypoll.PollChannel do
  use Phoenix.Channel

  alias Haypoll.Repo
  alias Haypoll.Entry

  def join("polls:" <> poll_id, _params, socket) do
    {:ok, socket}
  end

  def handle_in("new_vote", %{"entry_id" => entry_id}, socket) do
    entry     = Repo.get(Entry, entry_id)
    changeset = Entry.changeset(entry, %{votes: (entry.votes + 1)})
    case Repo.update(changeset) do
      {:ok, entry} ->
        broadcast!(socket, "new_vote", %{"entry_id" => entry.id})
        {:noreply, socket}
      {:error, _changeset} ->
        {:error, %{reason: "Failed to vote"}}
    end
  end
end
