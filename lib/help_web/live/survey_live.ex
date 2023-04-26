defmodule HelpWeb.SurveyLive do
  use HelpWeb, :live_view
  alias __MODULE__.Component
  alias Help.Survey
  alias Help.Catalog
  alias HelpWeb.DemographicLive
  alias HelpWeb.RatingLive
  alias HelpWeb.RatingLive.Show

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_demoraphic()
     |> assign_products()}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  defp assign_demoraphic(%{assigns: %{current_user: current_user}} = socket) do
    socket
    |> assign(:demographic, Survey.get_demographic_by_user(current_user))
  end

  defp assign_products(%{assigns: %{current_user: current_user}} = socket) do
    socket
    |> assign(:products, list_products(current_user))
  end

  defp list_products(user) do
    user
    |> Catalog.list_products_with_user_rating()
  end

  def handle_info({:created_demographic, demographic}, socket) do
    {:noreply, handle_demographic_created(socket, demographic)}

    # we don't need to re-mount LV
    # {:noreply, push_navigate(socket, to: ~p"/survey")}
  end

  defp handle_demographic_created(socket, demographic) do
    socket
    |> put_flash(:info, "Demographic created successfully")
    |> assign(:demographic, demographic)
  end
end
