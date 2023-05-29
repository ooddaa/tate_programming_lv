defmodule HelpWeb.Admin.DashboardLive do
  use HelpWeb, :live_view
  alias HelpWeb.Admin.{SurveyResultsLive, UserActivityLive}
  alias HelpWeb.{Endpoint}
  @survey_results_topic "survey_results"
  @user_activity_topic "user_activity"
  @survey_takers_topic "survey_takers_activity"

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Endpoint.subscribe(@survey_results_topic)
      Endpoint.subscribe(@user_activity_topic)
      Endpoint.subscribe(@survey_takers_topic)
    end

    {:ok,
     socket
     |> assign(:survey_results_component_id, "survey_results")
     |> assign(:user_activity_component_id, "user_activity")}
  end

  def handle_info(%{event: "rating_created"}, socket) do
    send_update(SurveyResultsLive, id: socket.assigns.survey_results_component_id)
    {:noreply, socket}
  end

  def handle_info(%{event: "presence_diff"}, socket) do
    send_update(UserActivityLive, id: socket.assigns.user_activity_component_id)
    {:noreply, socket}
  end
end
