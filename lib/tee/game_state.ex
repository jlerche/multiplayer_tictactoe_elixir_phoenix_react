defmodule Tee.GameState do
    use GenServer

    defstruct [
        id: nil,
        turn: :player_one,
        player_one: nil,
        player_two: nil,
        winner: nil,
        board: [
            "", "", "", "", "", "", "", "", ""
        ],
    ]

    # CLIENT

    def start_link(id) do
        GenServer.start_link(__MODULE__, id, name: {:global, {:game, id}})
    end

    def join(id, user, pid) do
        try_call(id, {:join, user, pid})
    end

    def update(id, board, player) do
        try_cast(id, {:update, player, board})
    end

    # SERVER

    def init(id) do
        {:ok, %__MODULE__{id: id}}
    end

    def handle_call({:join, user, pid}, _from, game) do
        cond do
            game.player_one != nil and game.player_two != nil ->
                {:reply, {:error, "No more players allowed"}, game}
            Enum.member?([game.player_one, game.player_two], user) ->
                {:reply, {:ok, self, game}, game}
            true ->
                Process.flag(:trap_exit, true)
                Process.monitor(pid)
                game = add_player(game, user)

                {:reply, {:ok, self, game}, game}
        end
    end

    def handle_cast({:update, board, player}, game) do
        game = %{game | board: board, turn: get_other_player(player),
                    winner: check_winner(board)}
        Tee.Endpoint.broadcast("game:" <> Integer.to_string(game.id), "state_update", game)
        {:noreply, game}
    end

    defp ref(id), do: {:global, {:game, String.to_integer(id)}}

    defp try_call(id, message) do
        case GenServer.whereis(ref(id)) do
            nil ->
                {:error, "Game does not exist"}
            pid ->
                GenServer.call(pid, message)
        end
    end

    defp try_cast(id, message) do
        case GenServer.whereis(ref(Integer.to_string(id))) do
            nil ->
                {:error, "Game does not exist"}
            pid ->
                GenServer.cast(pid, message)
        end
    end

    defp get_other_player(player) do
        case player do
            "player_one" -> :player_two
            "player_two" -> :player_one
        end
    end

    defp add_player(%__MODULE__{player_one: nil} = game, user) do
        %{game | player_one: user}
    end
    defp add_player(%__MODULE__{player_two: nil} = game, user) do
        %{game | player_two: user}
    end

    defp check_winner(["X", "X", "X", _, _, _, _, _, _]) do
        :player_one
    end

    defp check_winner(_) do
        nil
    end
end
