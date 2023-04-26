defmodule HelpWeb.DemographicLive.Show do
  use Phoenix.Component
  use Phoenix.HTML
  alias Help.Survey.Demographic

  attr :demographic, Demographic, required: true

  def details(assigns) do
    ~H"""
    <div>
      <h2 class={["font-medium text-2xl"]}>
        Demographics <%= raw("&#x2713;") %>
      </h2>
      <ul>
        <li>Gender: <%= @demographic.gender %></li>
        <li>Year of birth: <%= @demographic.year_of_birth %></li>
      </ul>
    </div>
    """
  end
end
