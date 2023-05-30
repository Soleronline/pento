# alias Pento.Accounts

defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}
  alias Pento.Accounts

  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])
    {:ok, assign(
      socket,
      score: 0,
      message: "Make a guess:",
      number: get_number(),
      session_id: session["live_socket_id"],
      current_user: user
      )
    }
  end

  def get_number do
    Enum.random(1..10)
  end

  def time() do
    DateTime.utc_now|>to_string
  end

  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <%= @number %><br>
    <h2>
      <%= @message %>
    </h2>
    <h2>
      <%= for n <- 1..10 do %>
        <a href="#" phx-click="guess" phx-value-number= {n} ><%= n %></a>
      <% end %>
      <pre>
        <%= @current_user.email %>
        <%= @session_id %>
      </pre>
    </h2>
    """
  end


  def handle_event("guess", %{"number" => guess} = data, socket) do
IO.puts(" #{is_integer(socket.assigns.number)} -- #{is_integer(guess)} - #{socket.assigns.number === guess}")
    if socket.assigns.number == guess|>String.to_integer do
      score = socket.assigns.score + 1
      number = get_number()
      message = "Congratulations"
      {
        :noreply,
        assign(
          socket,
          message: message,
          score: score,
          number: number
        )
      }
    else
      message = "Your guess: #{guess}. Wrong. Guess again"
      score = socket.assigns.score - 1
      {
        :noreply,
        assign(
          socket,
          message: message,
          score: score
        )
      }
    end
  end
end
