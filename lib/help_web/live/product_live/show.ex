defmodule HelpWeb.ProductLive.Show do
  use HelpWeb, :live_view

  alias Help.Catalog
  # alias HelpWeb.Presence
  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    product = Catalog.get_product!(id)
    IO.inspect("🥶 user visited product, gonna track")
    maybe_track_user(product, socket)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:product, Catalog.get_product!(id))}
  end

  defp page_title(:show), do: "Show Product"
  defp page_title(:edit), do: "Edit Product"

  defp maybe_track_user(
         product,
         %{assigns: %{live_action: :show, current_user: current_user}} = socket
       ) do
    IO.inspect(connected?(socket), label: "🥵 maybe_track_user: connected?(socket)")

    if connected?(socket) do
      IO.inspect("🚀 calling HelpWeb.Presence.track_user")
      HelpWeb.Presence.track_user(self(), product, current_user.email)
    end
  end

  defp maybe_track_user(_, _), do: nil
end
