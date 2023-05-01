defmodule HelpWeb.ButtonLive do
  use HelpWeb, :live_view

  alias HelpWeb.ButtonLive.Toggler
  alias HelpWeb.ButtonLive.Component

  def(mount(_params, _session, socket)) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <%!-- <.live_component module={Toggler} id="toggler" /> --%>
    <Component.toggler />
    """
  end
end
