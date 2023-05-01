defmodule HelpWeb.DemographicLive.Show do
  use Phoenix.Component
  use Phoenix.HTML
  alias Help.Survey.Demographic
  alias HelpWeb.CoreComponents

  attr :demographic, Demographic, required: true

  def details(assigns) do
    ~H"""
    <div>
      <h2 class={["font-medium text-2xl"]}>
        Demographics <%= raw("&#x2713;") %>
      </h2>
      <CoreComponents.table id="demographics" rows={[@demographic]}>
        <:col :let={demographic} label="Gender"><%= demographic.gender %></:col>
        <:col :let={demographic} label="Year of birth"><%= demographic.year_of_birth %></:col>
        <:col :let={demographic} label="Education"><%= demographic.education %></:col>
      </CoreComponents.table>
    </div>
    """
  end
end
