defmodule HelpWeb.ProductLive.FormComponent do
  use HelpWeb, :live_component

  alias Help.Catalog

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage product records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="product-form"
        multipart
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:unit_price]} type="number" label="Unit price" step="any" />
        <.input field={@form[:sku]} type="number" label="Sku" />
        <div phx-drop-target={@uploads.image.ref}>
          <.label>Choose image</.label>
          <.live_file_input upload={@uploads.image} class="bg-red-500" />
        </div>
        <:actions>
          <.button phx-disable-with="Saving...">Save Product</.button>
        </:actions>
      </.simple_form>
      <%= for image <- @uploads.image.entries do %>
        <div class="mt-4">
          <.live_img_preview entry={image} width={60} />
          <progress value={image.progress} max={100} />
        </div>
        <%= for error <- upload_errors(@uploads.image, image) do %>
          <.error><%= error %></.error>
        <% end %>
      <% end %>
    </div>
    """
  end

  @impl true
  def update(%{product: product} = assigns, socket) do
    # IO.inspect(product, label: "product")
    changeset = Catalog.change_product(product)
    # |> IO.inspect(label: "changeset")

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign_form(changeset)
      |> allow_upload(:image,
        accept: ~w(.jpg .jpeg .png),
        max_entries: 2,
        max_file_size: 9_000_000,
        auto_upload: true
      )
      #  |> IO.inspect()
    }
  end

  @impl true
  def handle_event("validate", %{"product" => product_params} = _params, socket) do
    # IO.inspect(params, label: "params")

    changeset =
      socket.assigns.product
      |> Catalog.change_product(product_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"product" => product_params}, socket) do
    save_product(socket, socket.assigns.action, product_params)
  end

  defp save_product(socket, :edit, product_params) do
    # product_params |> IO.inspect(label: "product_params")
    # product_params: %{
    #   "description" => "oooo",
    #   "name" => "hehe",
    #   "sku" => "1",
    #   "unit_price" => "1.0"
    # }
    product_params = params_with_image(socket, product_params)

    case Catalog.update_product(socket.assigns.product, product_params) do
      {:ok, product} ->
        notify_parent({:saved, product})

        {:noreply,
         socket
         |> put_flash(:info, "Product updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_product(socket, :new, product_params) do
    product_params = params_with_image(socket, product_params)

    case Catalog.create_product(product_params) do
      {:ok, product} ->
        notify_parent({:saved, product})

        {:noreply,
         socket
         |> put_flash(:info, "Product created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp params_with_image(socket, params) do
    # “It will need to consume any uploaded images, save them,
    # and then return a list of product parameters including the
    # image_upload path to the user.”

    # product_params |> IO.inspect(label: "product_params")
    # product_params: %{
    #   "description" => "oooo",
    #   "name" => "hehe",
    #   "sku" => "1",
    #   "unit_price" => "1.0",
    #   "image_upload" =>  "/images/image123.png"
    # }
    path =
      socket
      |> consume_uploaded_entries(:image, &upload_static_file/2)
      |> List.first()

    Map.put(params, "image_upload", path)
    # socket.assigns.uploads |> IO.inspect()

    # %{
    #   __phoenix_refs_to_names__: %{"phx-F1g53rG1P2f_fwVk" => :image},
    #   image: #Phoenix.LiveView.UploadConfig<
    #     name: :image,
    #     max_entries: 2,
    #     max_file_size: 9000000,
    #     entries: [
    #       %Phoenix.LiveView.UploadEntry{
    #         progress: 100,
    #         preflighted?: true,
    #         upload_config: :image,
    #         upload_ref: "phx-F1g53rG1P2f_fwVk",
    #         ref: "0",
    #         uuid: "d4674fec-faf3-41f2-b855-ffbac3b062b5",
    #         valid?: true,
    #         done?: true,
    #         cancelled?: false,
    #         client_name: "interview1.jpeg",
    #         client_relative_path: "",
    #         client_size: 98055,
    #         client_type: "image/jpeg",
    #         client_last_modified: 1681313221910
    #       }
    #     ],
    #     accept: ".jpg,.jpeg,.png",
    #     ref: "phx-F1g53rG1P2f_fwVk",
    #     errors: [],
    #     auto_upload?: true,
    #     progress_event: nil,
    #     ...
    #   >
    # }
  end

  defp upload_static_file(%{path: path} = _first, %{client_name: client_name} = _upload_entry) do
    # _first |> IO.inspect(label: "_first")
    # lol: %{
    #   path: "/var/folders/b0/z6ds2wjs4tsd6_w0l5l34wdw0000gn/T/plug-1682/live_view_upload-1682165049-734575590575-3"
    # }
    # upload_entry |> IO.inspect(label: "upload_entry")
    # %Phoenix.LiveView.UploadEntry{
    #   progress: 100,
    #   preflighted?: true,
    #   upload_config: :image,
    #   upload_ref: "phx-F1g6bppDVZhftwUj",
    #   ref: "0",
    #   uuid: "096c6992-49d3-464d-aeba-54b368e990bf",
    #   valid?: true,
    #   done?: true,
    #   cancelled?: false,
    #   client_name: "interview1.jpeg",
    #   client_relative_path: "",
    #   client_size: 98055,
    #   client_type: "image/jpeg",
    #   client_last_modified: 1681313221910
    # }
    filename = Path.basename(path)
    # |> IO.inspect()
    # live_view_upload-1682165049-734575590575-3
    # dest = Path.join("priv/static/images", filename)
    dir = "priv/static/images"
    unless File.exists?(dir), do: File.mkdir_p!(dir)

    dest = Path.join(dir, client_name)
    File.cp!(path, dest)

    {:ok, ~p"/images/#{client_name}"}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    # IO.inspect(changeset, label: "changeset")

    form = to_form(changeset)
    # |> IO.inspect(label: "form")

    assign(socket, :form, form)
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
