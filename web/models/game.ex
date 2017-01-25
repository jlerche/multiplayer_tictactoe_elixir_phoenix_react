defmodule Tee.Game do
  use Tee.Web, :model

  schema "games" do
    field :name, :string
    field :full, :boolean, default: false
    field :winner, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :full, :winner])
    |> validate_required([:name, :full, :winner])
  end
end
