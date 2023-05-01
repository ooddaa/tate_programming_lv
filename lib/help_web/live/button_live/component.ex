defmodule HelpWeb.ButtonLive.Component do
  use HelpWeb, :html

  alias Phoenix.LiveView.JS

  def toggler(assigns) do
    ~H"""
    <div>
    <.button phx-click={JS.toggle(to: "#div-to-hide")}>
    <%= "Toggle" %>
    </.button>
    <div id="div-to-hide"> Div to hide </div>
    </div>
    """
  end
end
