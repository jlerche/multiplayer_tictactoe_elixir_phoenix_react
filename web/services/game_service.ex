defmodule Tee.GameService do
    alias Tee.{Repo, Game}
    alias Ecto.Multi

    def update(id, changes) do
        changeset = Repo.get(Game, id) |> Game.changeset(changes)
        Multi.new
        |> Multi.update(:game, changeset)
        |> Multi.run(:broadcast_rem, &broadcast_rem/1)
    end

    def create(changeset) do
        Multi.new
        |> Multi.insert(:game, changeset)
        |> Multi.run(:broadcast_add, &broadcast_add/1)

    end

    defp broadcast_rem(%{game: game}) do
        Tee.Endpoint.broadcast!("lobby:lobby", "rem_game", %{id: game.id, name: game.name})
        {:ok, :noreply}
    end

    defp broadcast_add(%{game: game}) do
        Tee.Endpoint.broadcast!("lobby:lobby", "add_game", %{id: game.id, name: game.name})
        {:ok, :noreply}
    end


end
