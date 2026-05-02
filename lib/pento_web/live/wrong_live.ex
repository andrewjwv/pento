defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view
  alias Pento.Accounts
  def mount(_params, session, socket) do
    {:ok, assign(socket, score: 0, message: "Make a guess",session_id: session["live_socket_id"], number: Enum.random(1..10), time: time() |> to_string,  won: false)}
  end
  def render (assigns) do
    ~H"""
    <h1 class="mb-4 test-4xl font-ex-trabold">Your score: {@score}</h1>
    <h2>
      {@message}
      It's <%= @time %>
    </h2>
    <br />
    <h2>
      <%= for n <- 1..10 do %>
        <.link
          class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded m-1"
          phx-click="guess"
          phx-value-number={n}
        >
          {n}
        </.link>
      <% end %>
    </h2>
    <br />
    <pre>
      {@session_id}
    </pre>
    <h2>
    <%= if @won do %>
      <.link
          class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded m-1"
          phx-click="won"
      >
        You did it! Try again?
      </.link>
    <% end %>

    </h2>
    """
  end
  def handle_event("guess", %{"number" => guess}, socket) do
    number = socket.assigns.number
    IO.inspect number
    {message, score, number, won} = if guess == to_string(number) do
      {"Your guess: #{guess}. That is correct! Want to play again?", socket.assigns.score + 1, Enum.random(1..10), true}
    else
      {"Your guess: #{guess}. Wrong. Guess Again.", socket.assigns.score - 1, number, false}
    end

    {
      :noreply,
      assign(
        socket,
        message: message,
        score: score,
        number: number,
        time: time(),
        won: won
      )
    }
  end
  def handle_event("won",_params, socket) do
    won = false
    {
      :noreply,
      assign(
        socket,
        won: won,
        time: time()
      )
    }
  end

  def time() do
    DateTime.utc_now() |> to_string
  end
end
