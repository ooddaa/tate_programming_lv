defmodule HelpWeb.SearchLive do
  use HelpWeb, :live_view

  alias Help.Search
  alias Help.Search.SearchSku

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_search()
     |> assign_changeset()
     |> assign_form()}
  end

  def assign_search(socket) do
    socket
    |> assign(:search, %SearchSku{})
  end

  def assign_changeset(%{assigns: %{search: search}} = socket) do
    socket
    |> assign(:changeset, Search.change_search_sku(search))
  end

  def assign_form(%{assigns: %{changeset: changeset}} = socket) do
    socket
    |> assign(:form, to_form(changeset))
  end

  def handle_event(
        "validate",
        %{"search_sku" => search_sku} = _params,
        %{assigns: %{search: search}} = socket
      ) do
    # IO.inspect(params, label: "validate params")
    changeset =
      search
      |> Search.change_search_sku(search_sku)
      |> Map.put(:action, :validate)

    # {:noreply, socket |> assign(:changeset, changeset)}
    {:noreply, socket |> assign(:form, to_form(changeset))}
  end

  def handle_event("save", _unsigned_params, socket) do
    {:noreply, socket}
  end
end
