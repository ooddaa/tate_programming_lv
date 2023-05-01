defmodule HelpWeb.ButtonLive.Toggler do
  use HelpWeb, :live_component

  attr(:open?, :boolean, default: true)

  def render(assigns) do
    ~H"""
    <div>
    <.button phx-click="toggle" phx-value-open={to_string(@open?)} phx-target={@myself}>
    <%= "open?: #{@open?}" %>
    </.button>
    <div :if={@open?}> Div to hide </div>
    <%!-- <div style={if @open?, do: "", else: "display: none"}> Div to hide </div> --%>
    </div>
    """
  end

  def handle_event("toggle", %{"open" => open} = unsigned_params, socket) do
    {:noreply, assign(socket, :open?, if(open == "true", do: false, else: true))}
  end
end
