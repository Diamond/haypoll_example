defmodule Haypoll.EntryTest do
  use Haypoll.ModelCase

  alias Haypoll.Entry

  @valid_attrs %{title: "some content", votes: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Entry.changeset(%Entry{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Entry.changeset(%Entry{}, @invalid_attrs)
    refute changeset.valid?
  end
end
