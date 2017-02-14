defmodule Tee.GameSupervisor do
    use Supervisor
    alias Tee.GameState

    def start_link, do: Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)

    def init(:ok) do
        children = [
            worker(GameState, [], restart: :temporary)
        ]
        supervise(children, strategy: :simple_one_for_one)
    end

    def create_game(id) do
        Supervisor.start_child(__MODULE__, [id])
    end
end
