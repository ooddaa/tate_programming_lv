defmodule HelpWeb.WrongLive do
  use HelpWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       score: 0,
       message: "Let's play",
       guess: (:rand.uniform() * 10) |> round,
       time: time_now(),
       won?: false
     )}

    # |> IO.inspect()

    # {:ok,
    #  #Phoenix.LiveView.Socket<
    #    id: "phx-F1HtkIPvgGBkqgYj",
    #    endpoint: HelpWeb.Endpoint,
    #    view: HelpWeb.WrongLive,
    #    parent_pid: nil,
    #    root_pid: #PID<0.1750.0>,
    #    router: HelpWeb.Router,
    #    assigns: %{
    #      __changed__: %{
    #        current_user: true,
    #        guess: true,
    #        message: true,
    #        score: true,
    #        time: true,
    #        user: true,
    #        won?: true
    #      },
    #      current_user: #Help.Accounts.User<
    #        __meta__: #Ecto.Schema.Metadata<:loaded, "users">,
    #        id: 1,
    #        email: "ooddaa@gmail.com",
    #        confirmed_at: ~N[2023-04-01 18:40:00],
    #        inserted_at: ~N[2023-04-01 18:39:21],
    #        updated_at: ~N[2023-04-01 18:40:00],
    #        ...
    #      >,
    #      flash: %{},
    #      guess: 10,
    #      live_action: nil,
    #      message: "Let's play",
    #      score: 0,
    #      session_id: "users_sessions:JQ76DRto3y2nTt7ZZrMUPIssX0fUdlrM5kwVD6yk_ZA=",
    #      time: "2023-04-01 21:42:22.078353Z",
    #      won?: false
    #    },
    #    transport_pid: #PID<0.1743.0>,
    #    ...
    #  >}
  end

  @impl true
  @spec render(map) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <div>
      <h1 class="text-red-500">
        Your score: <%= @score %>
      </h1>
      <%!-- <h1 class="text-red-500">
        Time guessed: <%= @time %>
      </h1> --%>
      <h2>
        Message: <%= @message %>
      </h2>
      <h2>
        <%= for n <- 1..10 do %>
          <.link href="#" phx-click="guess" phx-value-number={n}>
            <%= n %>
          </.link>
        <% end %>
      </h2>
    </div>
    <%= if @won? do %>
      <button phx-click="restart">Restart</button>
    <% end %>
    """
  end

  defp time_now, do: DateTime.utc_now() |> to_string()

  @impl true
  def handle_event("guess", %{"number" => guess}, socket) do
    time = time_now()

    case String.to_integer(guess) == socket.assigns.guess do
      true ->
        message = "Yay! You won! 🤗 Let's play again!"
        score = socket.assigns.score + 1
        guess = (:rand.uniform() * 10) |> round

        {:noreply,
         assign(socket, message: message, score: score, guess: guess, time: time, won?: true)}

      false ->
        message = "You guessed: #{guess}. 👎"
        score = socket.assigns.score - 1
        {:noreply, assign(socket, message: message, score: score, time: time, won?: false)}
    end
  end

  @impl true
  def handle_event("restart", _, socket) do
    {:noreply, socket |> push_patch(to: "/guess")}
  end
end
