defmodule HelpWeb.CardLive do
  use HelpWeb, :live_view

  @cards [:simple, :playful, :elegant, :brutalist]
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_card()}
  end

  def assign_card(socket) do
    socket
    |> assign(:card, :simple)
  end

  def handle_event("next_card", _unsigned_params, %{assigns: %{card: card}} = socket) do
    # implement fsm
    next_card =
      card
      |> get_next(@cards)

    {:noreply, socket |> assign(:card, next_card)}
  end

  def handle_event("prev_card", _unsigned_params, %{assigns: %{card: card}} = socket) do
    # implement fsm
    {:noreply, socket |> assign(:card, get_prev(card, @cards))}
  end

  def get_next(card, cards) do
    index =
      cards
      |> Enum.find_index(&(&1 == card))

    cards
    |> Enum.at(Integer.mod(index + 1, length(@cards)))
  end

  def get_prev(card, cards) do
    index =
      cards
      |> Enum.find_index(&(&1 == card))

    cards
    |> Enum.at(
      if index == 0,
        do: length(@cards) - 1,
        else: index - 1
    )
  end
end
