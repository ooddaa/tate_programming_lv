defmodule HelpWeb.Admin.DashboardLive do
  use HelpWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:survey_results_component_id, "survey_results")}
  end
end
