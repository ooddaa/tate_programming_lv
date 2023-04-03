defmodule HelpWeb.CompanyLive.Index do
  use HelpWeb, :live_view

  alias Help.Employers
  alias Help.Employers.Company

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :companies, Employers.list_companies())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    case Map.get(socket.assigns, :current_user) do
      nil ->
        socket
        |> assign(:page_title, "Listing Companies")
        |> assign(:company, nil)

      _user ->
        socket
        |> push_patch(to: ~p"/guess")
    end
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Company")
    |> assign(:company, Employers.get_company!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Company")
    |> assign(:company, %Company{})
  end

  @impl true
  def handle_info({HelpWeb.CompanyLive.FormComponent, {:saved, company}}, socket) do
    {:noreply, stream_insert(socket, :companies, company)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    company = Employers.get_company!(id)
    {:ok, _} = Employers.delete_company(company)

    {:noreply, stream_delete(socket, :companies, company)}
  end
end
