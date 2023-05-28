defmodule HelpWeb.Admin.SurveyResultsLive do
  use HelpWeb, :live_component
  use HelpWeb, :chart_live
  alias Help.Catalog
  alias Contex.Plot

  def mount(socket) do
    {:ok, socket}
  end

  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign_gender_filter()
      |> assign_age_group_filter()
      |> assign_products_with_average_ratings()
      |> assign_dataset()
      |> assign_chart()
      |> assign_chart_svg()
    }
  end

  defp assign_gender_filter(%{assigns: %{gender_filter: gender_filter}} = socket) do
    socket
  end

  defp assign_gender_filter(%{assigns: assigns} = socket, filter \\ "all") do
    socket
    |> assign(:gender_filter, filter)
  end

  defp assign_age_group_filter(%{assigns: %{age_group_filter: age_group_filter}} = socket) do
    socket
  end

  defp assign_age_group_filter(%{assigns: assigns} = socket, filter \\ "all") do
    socket
    |> assign(:age_group_filter, filter)
  end

  @spec assign_products_with_average_ratings(map) :: map
  defp assign_products_with_average_ratings(
         %{
           assigns: %{
             age_group_filter: age_group_filter,
             gender_filter: gender_filter
           }
         } = socket
       ) do
    socket
    |> assign(
      :products_with_average_ratings,
      get_products_with_average_ratings(%{
        age_group_filter: age_group_filter,
        gender_filter: gender_filter
      })
    )
  end

  defp get_products_with_average_ratings(filters) do
    case Catalog.product_with_average_ratings(filters) do
      [] ->
        Catalog.products_with_zero_ratings()

      products ->
        products
    end
  end

  defp assign_dataset(
         %{
           assigns: %{
             products_with_average_ratings: products_with_average_ratings
           }
         } = socket
       ) do
    socket
    |> assign(:dataset, make_bar_chart_dataset(products_with_average_ratings))
  end

  defp assign_chart(%{assigns: %{dataset: dataset}} = socket) do
    socket
    |> assign(:chart, make_bar_chart(dataset))
  end

  defp assign_chart_svg(%{assigns: %{chart: chart}} = socket) do
    socket
    |> assign(:chart_svg, render_bar_chart(chart, title(), subtitle(), x_axis(), y_axis()))
  end

  defp title, do: "Product Ratings"
  defp subtitle, do: "average star ratings per product"
  defp x_axis, do: "products"
  defp y_axis, do: "stars"

  def handle_event("gender_filter", %{"gender_filter" => gender_filter}, socket) do
    {
      :noreply,
      socket
      |> assign_gender_filter(gender_filter)
      |> assign_products_with_average_ratings()
      |> assign_dataset()
      |> assign_chart()
      |> assign_chart_svg()
    }
  end

  def handle_event("age_group_filter", %{"age_group_filter_name" => age_group_filter}, socket) do
    {
      :noreply,
      socket
      |> assign_age_group_filter(age_group_filter)
      |> assign_products_with_average_ratings()
      |> assign_dataset()
      |> assign_chart()
      |> assign_chart_svg()
    }
  end

  def handle_event(_event, _params, socket) do
    {:noreply, socket}
  end
end
