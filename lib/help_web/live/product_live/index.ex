defmodule HelpWeb.ProductLive.Index do
  use HelpWeb, :live_view

  alias Help.Catalog
  alias Help.Catalog.Product

  @impl true
  def mount(_params, _session, socket) do
    # https://hexdocs.pm/phoenix_live_view/0.18.18/Phoenix.LiveView.html#stream/4
    {
      :ok,
      socket
      |> stream(:products, Catalog.list_products())
      |> assign(:greeting, "Welcome to Mars")
      #  |> IO.inspect()
    }

    # assigns: %{
    #   __changed__: %{current_user: true, session_id: true, streams: true},
    #   current_user: #Help.Accounts.User<
    #     __meta__: #Ecto.Schema.Metadata<:loaded, "users">,
    #     id: 1,
    #     username: "oda",
    #     email: "ooddaa@gmail.com",
    #     confirmed_at: nil,
    #     inserted_at: ~N[2023-04-17 14:47:13],
    #     updated_at: ~N[2023-04-17 14:47:13],
    #     ...
    #   >,
    #   flash: %{"info" => "Account created successfully!"},
    #   live_action: :index,
    #   session_id: "users_sessions:q7oKjYppI0kW50C_67MIWlRhBfW9HvR0fJoqCQ4wwXE=",
    #
    #
    #   streams: %{
    #     __changed__: MapSet.new([:products]),
    #     products: %Phoenix.LiveView.LiveStream{
    #       name: :products,
    #       dom_id: #Function<3.113057034/1 in Phoenix.LiveView.LiveStream.new/3>,
    #       inserts: [],
    #       deletes: []
    #     }
    #   }
    # },
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, Catalog.get_product!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Product")
    |> assign(:product, %Product{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Products")
    |> assign(:product, nil)
  end

  @impl true
  def handle_info({HelpWeb.ProductLive.FormComponent, {:saved, product}}, socket) do
    {:noreply, stream_insert(socket, :products, product)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product = Catalog.get_product!(id)
    {:ok, _} = Catalog.delete_product(product)

    {:noreply, stream_delete(socket, :products, product)}
  end
end
