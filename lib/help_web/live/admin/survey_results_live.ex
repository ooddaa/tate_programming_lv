defmodule HelpWeb.Admin.SurveyResultsLive do
  use HelpWeb, :live_component
  alias Help.Catalog

  def mount(socket) do
    {:ok, socket}
  end

  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign_products_with_average_ratings()
      |> assign_dataset()
      #  |> IO.inspect()
    }
  end

  @spec assign_products_with_average_ratings(map) :: map
  def assign_products_with_average_ratings(socket) do
    socket
    |> assign(:products_with_average_ratings, Catalog.product_with_average_ratings())
  end

  def assign_dataset(
        %{
          assigns: %{
            products_with_average_ratings: products_with_average_ratings
          }
        } = socket
      ) do
    socket
    |> assign(:dataset, make_bar_chart_dataset(products_with_average_ratings))
  end

  def make_bar_chart_dataset(data) do
    Contex.Dataset.new(data)
    # |> IO.inspect(label: "dataset: ")
    # dataset: : %Contex.Dataset{
    #   headers: nil,
    #   data: [{"test product", 5.0}, {"adasf", 4.0}],
    #   title: nil
    # }
  end
end
