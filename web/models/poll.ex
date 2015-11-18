defmodule Haypoll.Poll do
  use Haypoll.Web, :model

  schema "polls" do
    field :title, :string
    field :closed, :boolean, default: false

    has_many :entries, Haypoll.Entry, on_delete: :delete_all

    timestamps
  end

  @required_fields ~w(title closed)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
