defmodule HelpWeb.ButtonLive do
  use HelpWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_toggle_state()}
  end

  def assign_toggle_state(socket) do
    socket
    |> assign(:open?, true)
  end

  def render(assigns) do
    ~H"""
    <div>
    <.button phx-click="toggle">
    <%= "open?: #{@open?}" %>
    </.button>
    <div :if={@open?}> Div to hide </div>
    <%!-- <div style={if @open?, do: "", else: "display: none"}> Div to hide </div> --%>
    </div>
    """
  end

  def handle_event("toggle", _unsigned_params, %{assigns: %{open?: open}} = socket) do
    {:noreply, assign(socket, :open?, not open)}
  end
end
