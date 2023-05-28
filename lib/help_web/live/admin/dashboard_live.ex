defmodule HelpWeb.Admin.DashboardLive do
  use HelpWeb, :live_view
  alias HelpWeb.Admin.SurveyResultsLive
  alias HelpWeb.{Endpoint}
  @survey_results_topic "survey-results"

  def mount(_params, _session, socket) do
    if connected?(socket), do: Endpoint.subscribe(@survey_results_topic)

    {:ok,
     socket
     |> assign(:survey_results_component_id, "survey_results")}
  end

  def handle_info(%{event: "rating_created"}, socket) do
    send_update(SurveyResultsLive, id: socket.assigns.survey_results_component_id)
    {:noreply, socket}
  end
end
