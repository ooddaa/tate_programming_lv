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

  def handle_event("save", %{"rating" => rating_params} = _unsigned_params, socket) do
    # form is named after "schema" singular name
    # "ratings" -> rating
    # "lols" -> lol
    # IO.inspect(rating_params, label: "rating_params")
    # rating_params: %{"product_id" => "1", "stars" => "5", "user_id" => "2"}
    {:noreply, save_rating(socket, rating_params)}
  end

  def handle_event("change", %{"rating" => rating_params} = unsigned_params, socket) do
    # IO.inspect(rating_params, label: "rating_params")
    # rating_params: %{"product_id" => "9", "stars" => "4", "user_id" => "2"}
    {:noreply, save_rating(socket, rating_params)}
  end

  def save_rating(%{assigns: %{product_index: product_index, product: product}} = socket, params) do
    case Survey.create_rating(params) do
      {:ok, rating} ->
        # send parent all info so it can
        # re-render the view
        product = %{product | ratings: [rating]}
        send(self(), {:created_rating, product, product_index})
        socket

      {:error, changeset} ->
        socket
        |> assign(:changeset, changeset)
        |> assign(:form, to_form(changeset))
    end
  end
end
