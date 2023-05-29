defmodule HelpWeb.SurveyLive.Component do
  use Phoenix.Component

  attr :content, :string, required: true
  slot :inner_block, required: true

  def hero(assigns) do
    ~H"""
    <h1 class="font-heavy text-3xl">
      <%= @content %>
    </h1>
    <h3>
      <%= render_slot(@inner_block) %>
    </h3>
    """
  end

  attr :heading, :string, required: true
  attr :message, :string

  def title(assigns) do
    ~H"""
    <h1><%= @heading %></h1>
    <%= @message %>
    """
  end

  attr :item, :string, required: true

  def list_item(assigns) do
    ~H"""
    <li><%= @item %></li>
    """
  end

  attr :items, :list, required: true

  def list(assigns) do
    ~H"""
    <ul>
      <%= for item <- @items do %>
        <.list_item item={item} />
      <% end %>
    </ul>
    """
  end
end
