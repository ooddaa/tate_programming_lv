defmodule HelpWeb.SurveyLive do
  @moduledoc """
  Manages lists of products and ratings
  """
  use HelpWeb, :live_view
  alias __MODULE__.Component
  alias Help.Survey
  alias Help.Catalog
  alias HelpWeb.{DemographicLive, RatingLive, Endpoint}

  @survey_results_topic "survey-results"

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_demoraphic()
     |> assign_products()}
  end

  def handle_params(_params, _uri, %{assigns: %{current_user: current_user}} = socket) do
    IO.inspect("😵‍💫 user is doing the survey, gonna track")
    maybe_track_current_user(socket)
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

  def handle_info({:created_rating, updated_product, product_index}, socket) do
    {:noreply, handle_rating_created(socket, updated_product, product_index)}
  end

  defp handle_demographic_created(socket, demographic) do
    socket
    |> put_flash(:info, "Demographic created successfully")
    |> assign(:demographic, demographic)
  end

  defp handle_rating_created(
         %{assigns: %{products: products}} = socket,
         updated_product,
         product_index
       ) do
    Endpoint.broadcast(@survey_results_topic, "rating_created", %{})

    socket
    |> put_flash(:info, "Rating created successfully")
    |> assign(:products, List.replace_at(products, product_index, updated_product))
  end

  defp maybe_track_current_user(%{assigns: %{current_user: current_user}} = socket) do
    if connected?(socket) do
      HelpWeb.Presence.track_user(self(), current_user, current_user.username)
    end
  end

  defp maybe_track_user(_, _), do: nil
end
