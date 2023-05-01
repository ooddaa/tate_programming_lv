defmodule HelpWeb.RatingLive.Index do
  use Phoenix.Component
  use Phoenix.HTML
  alias HelpWeb.RatingLive
  alias HelpWeb.RatingLive.Show

  attr :products, :list, required: true
  attr :current_user, :any, required: true

  def product_list(assigns) do
    ~H"""
    <.heading products={@products} />
    <div class={["grid grid-cols-2 gap-4 divide-y"]}>
      <.product_rating
        :for={{p, i} <- Enum.with_index(@products)}
        current_user={@current_user}
        product={p}
        index={i}
      />
    </div>
    """
  end

  attr :products, :list, required: true

  def heading(assigns) do
    ~H"""
    <h2 class={["font-medium text-2xl"]}>
      Ratings <%= if ratings_complete?(@products), do: raw("&#x2713;") %>
    </h2>
    """
  end

  defp ratings_complete?(products) do
    Enum.all?(products, fn p ->
      not Enum.empty?(p.ratings)
    end)
  end

  attr :product, :any, required: true
  attr :current_user, :any, required: true
  attr :index, :integer, required: true

  def product_rating(assigns) do
    ~H"""
    <div><%= @product.name %></div>
    <%= if rating = List.first(@product.ratings) do %>
      <Show.stars rating={rating} />
    <% else %>
      <.live_component
        module={HelpWeb.RatingLive.Form}
        id={"rating-form-#{@product.id}"}
        current_user={@current_user}
        product_index={@index}
        product={@product}
      />
      <%!-- <div>
        <h3>
          <%= @product.name %> rating form coming soon
        </h3>
      </div> --%>
    <% end %>
    """
  end
end
