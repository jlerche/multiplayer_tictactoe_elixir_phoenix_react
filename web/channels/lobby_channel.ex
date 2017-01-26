defmodule Tee.LobbyChannel do
  use Tee.Web, :channel
  alias Tee.Repo
  alias Tee.Game

  def join("lobby:lobby", payload, socket) do
      query = from g in Game, where: g.full == false, select: g
      case query |> Repo.all do
          nil -> {:error, %{reason: "No"}}
          res -> {:ok, %{"games" => queryres_to_list(res)}, socket}
      end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (lobby:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end


  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  defp queryres_to_list(result) do
      for n <- result, do: %{"id" => n.id, "name" => n.name}
  end

end
