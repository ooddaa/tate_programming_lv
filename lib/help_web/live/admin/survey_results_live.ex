defmodule HelpWeb.Admin.SurveyResultsLive do
  use HelpWeb, :live_component
  alias Help.Catalog

  def mount(socket) do
    {:ok, socket}
  end

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_products_with_average_ratings()
     |> IO.inspect()}
  end

  @spec assign_products_with_average_ratings(map) :: map
  def assign_products_with_average_ratings(socket) do
    socket
    |> assign(:products_with_average_ratings, Catalog.product_with_average_ratings())
  end
end
