defmodule HelpWeb.ButtonLive do
  use HelpWeb, :live_view

  alias HelpWeb.ButtonLive.Toggler

  def(mount(_params, _session, socket)) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.live_component module={Toggler} id="toggler" />
    """
  end
end
