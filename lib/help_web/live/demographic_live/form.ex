defmodule HelpWeb.DemographicLive.Form do
  use HelpWeb, :live_component
  alias Help.Survey
  alias Help.Survey.Demographic

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_demographic()
     |> assign_changeset()
     |> assign_form()}
  end

  def assign_demographic(%{assigns: %{current_user: user}} = socket) do
    socket
    |> assign(:demographic, %Demographic{user_id: user.id})
  end

  def assign_changeset(%{assigns: %{demographic: demographic}} = socket) do
    socket
    |> assign(:changeset, Survey.change_demographic(demographic))
  end

  def assign_form(%{assigns: %{changeset: changeset}} = socket) do
    socket
    |> assign(:form, to_form(changeset))
  end

  def handle_event("save", %{"demographic" => demographic} = _params, socket) do
    # IO.inspect(unsigned_params, label: "unsigned_params")
    # unsigned_params: %{
    #   "demographic" => %{
    #     "gender" => "male",
    #     "user_id" => "2",
    #     "year_of_birth" => "2005"
    #   }
    # }

    case Survey.create_demographic(demographic) do
      {:ok, _} ->
        {:noreply, push_navigate(socket, to: ~p"/survey")}

      _ ->
        {:noreply, socket}
    end

    #     {:ok,
    #  %Help.Survey.Demographic{
    #    __meta__: #Ecto.Schema.Metadata<:loaded, "demographics">,
    #    id: 3,
    #    gender: "male",
    #    year_of_birth: 2005,
    #    user_id: 2,
    #    user: #Ecto.Association.NotLoaded<association :user is not loaded>,
    #    inserted_at: ~N[2023-04-26 12:40:16],
    #    updated_at: ~N[2023-04-26 12:40:16]
    #  }}
    # {:noreply, socket}
    # {:noreply, push_patch(socket, to: ~p"/survey")}
  end
end
