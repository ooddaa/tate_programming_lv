defmodule HelpWeb.RatingLive.Form do
  use HelpWeb, :live_component
  alias Help.Survey
  alias Help.Survey.Rating

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_rating()
     |> assign_changeset()
     |> assign_form()}
  end

  def assign_rating(%{assigns: %{current_user: user, product: product}} = socket) do
    socket
    |> assign(:rating, %Rating{user_id: user.id, product_id: product.id})
  end

  def assign_changeset(%{assigns: %{rating: rating}} = socket) do
    socket
    |> assign(:changeset, Survey.change_rating(rating))
  end

  def assign_form(%{assigns: %{changeset: changeset}} = socket) do
    socket
    |> assign(:form, to_form(changeset))
  end
end
