defmodule Tee.GameState do
    use GenServer

    defstruct [
        id: nil,
        turn: :player_one,
        player_one: nil,
        player_two: nil,
        winner: nil
    ]

    # CLIENT

    def start_link(id) do
        GenServer.start_link(__MODULE__, id, name: {:global, {:game, id}})
    end

    def join(id, user, pid) do
        try_call(id, {:join, user, pid})
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

    defp ref(id), do: {:global, {:game, String.to_integer(id)}}

    defp try_call(id, message) do
        case GenServer.whereis(ref(id)) do
            nil ->
                {:error, "Game does not exist"}
            pid ->
                GenServer.call(pid, message)
        end
    end

    defp add_player(%__MODULE__{player_one: nil} = game, user) do
        %{game | player_one: user}
    end
    defp add_player(%__MODULE__{player_two: nil} = game, user) do
        %{game | player_two: user}
    end
end
