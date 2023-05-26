defmodule HelpWeb.Admin.SurveyResultsLive do
  use HelpWeb, :live_component
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
      |> assign_age_group_filter()
      |> assign_products_with_average_ratings()
      |> assign_dataset()
      |> assign_chart()
      |> assign_chart_svg()
      #  |> IO.inspect()
    }
  end

  defp assign_age_group_filter(socket, filter \\ "all") do
    socket
    |> assign(:age_group_filter, filter)
  end

  @spec assign_products_with_average_ratings(map) :: map
  defp assign_products_with_average_ratings(
         %{assigns: %{age_group_filter: age_group_filter}} = socket
       ) do
    socket
    |> assign(
      :products_with_average_ratings,
      get_products_with_average_ratings(age_group_filter)
    )
  end

  defp get_products_with_average_ratings(age_group_filter) do
    case Catalog.product_with_average_ratings(%{age_group_filter: age_group_filter}) do
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

  defp make_bar_chart_dataset(data) do
    Contex.Dataset.new(data)
    # |> IO.inspect(label: "dataset: ")
    # dataset: : %Contex.Dataset{
    #   headers: nil,
    #   data: [{"test product", 5.0}, {"adasf", 4.0}],
    #   title: nil
    # }
  end

  defp assign_chart(%{assigns: %{dataset: dataset}} = socket) do
    socket
    |> assign(:chart, make_bar_chart(dataset))
  end

  defp make_bar_chart(dataset) do
    Contex.BarChart.new(dataset)
    # |> IO.inspect(label: "chart: ")
    # %Contex.BarChart{
    #   dataset: %Contex.Dataset{
    #     headers: nil,
    #     data: [{"test product", 5.0}, {"adasf", 4.0}],
    #     title: nil
    #   },
    #   mapping: %Contex.Mapping{
    #     column_map: %{category_col: 0, value_cols: [1]},
    #     accessors: %{
    #       category_col: #Function<11.75387700/1 in Contex.Dataset.value_fn/2>,
    #       value_cols: [#Function<11.75387700/1 in Contex.Dataset.value_fn/2>]
    #     },
    #     expected_mappings: [category_col: :exactly_one, value_cols: :one_or_more],
    #     dataset: %Contex.Dataset{
    #       headers: nil,
    #       data: [{"test product", 5.0}, {"adasf", 4.0}],
    #       title: nil
    #     }
    #   },
    #   options: [
    #     type: :stacked,
    #     orientation: :vertical,
    #     axis_label_rotation: :auto,
    #     custom_value_scale: nil,
    #     custom_value_formatter: nil,
    #     width: 100,
    #     height: 100,
    #     padding: 2,
    #     data_labels: true,
    #     colour_palette: :default,
    #     phx_event_handler: nil,
    #     phx_event_target: nil,
    #     select_item: nil
    #   ],
    #   category_scale: nil,
    #   value_scale: nil,
    #   series_fill_colours: nil,
    #   phx_event_handler: nil,
    #   value_range: nil,
    #   select_item: nil
    # }
  end

  defp assign_chart_svg(%{assigns: %{chart: chart}} = socket) do
    socket
    |> assign(:chart_svg, render_bar_chart(chart))
  end

  defp render_bar_chart(chart) do
    Plot.new(500, 400, chart)
    |> Plot.titles(title(), subtitle())
    |> Plot.axis_labels(x_axis(), y_axis())
    |> Plot.to_svg()
  end

  defp title, do: "Product Ratings"
  defp subtitle, do: "average star ratings per product"
  defp x_axis, do: "products"
  defp y_axis, do: "stars"

  def handle_event("gender_filter", params, socket) do
    # IO.inspect(params, label: "gender_filter params")
    # gender_filter params: %{"_target" => ["gender_filter"], "gender_filter" => "female"}
    {:noreply, socket}
  end

  def handle_event("age_group_filter", %{"age_group_filter_name" => age_group_filter}, socket) do
    IO.inspect(age_group_filter, label: "age_group_filter")

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
