defmodule HelpWeb.Admin.UserActivityLive do
  use HelpWeb, :live_component
  alias HelpWeb.Presence

  def update(_assigns, socket) do
    {
      :ok,
      socket
      |> assign_user_activity()
      |> assign_survey_takers()
    }
  end

  defp assign_user_activity(socket) do
    socket
    |> assign(:user_activity, Presence.list_products_and_users())
  end

  defp assign_survey_takers(socket) do
    survey_takers =
      Presence.list_survey_takers()
      |> length()

    socket
    |> assign(:survey_takers, survey_takers)
  end
end
