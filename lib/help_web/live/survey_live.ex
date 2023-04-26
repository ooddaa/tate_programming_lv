defmodule HelpWeb.SurveyLive do
  use HelpWeb, :live_view
  alias __MODULE__.Component
  alias Help.Survey
  alias HelpWeb.DemographicLive

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_demoraphic()}
  end

  defp assign_demoraphic(%{assigns: %{current_user: current_user}} = socket) do
    socket
    |> assign(:demographic, Survey.get_demographic_by_user(current_user))
  end
end
