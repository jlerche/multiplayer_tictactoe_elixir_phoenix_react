defmodule Tee.GameChannel do
    use Tee.Web, :channel
    alias Tee.Presence
    alias Tee.GameState

    def join("game:" <> game_id, _payload, socket) do
        send self, :after_join
        user = socket.assigns.user
        case GameState.join(game_id, user, socket.channel_pid) do
            {:ok, _pid, game} ->
                %{^user => player} = get_player_info(game)
                # push socket, "init_sync", %{game: game, player: player}
                socket = assign(socket, :player, player) |> assign(:game, game)
                send self, :init_sync
                {:ok, socket}
            {:error, reason} ->
                {:error, %{reason: reason}}
        end
    end

    def handle_in("game_joined", message, socket) do
        user = socket.assigns.user
    end

    def handle_info(:init_sync, socket) do
        push socket, "init_sync", %{game: socket.assigns.game, player: socket.assigns.player}
        {:noreply, socket}
    end

    def handle_info(:after_join, socket) do
        user = socket.assigns.user
        {:ok, _} = Presence.track(socket, user, %{
            online_at: inspect(System.system_time(:seconds))
            })
        push socket, "presence_state", Presence.list(socket)
        {:noreply, socket}
    end

    defp get_player_info(game) do
        player_one = game.player_one
        cond do
            game.player_two == nil ->
                players = %{player_one => :player_one}
            true ->
                players = %{player_one => :player_one, game.player_two => :player_two}
        end
    end

end
