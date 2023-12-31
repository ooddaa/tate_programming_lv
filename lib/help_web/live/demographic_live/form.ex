defmodule HelpWeb.DemographicLive.Form do
  use HelpWeb, :live_component
  alias Help.Survey
  alias Help.Survey.Demographic

  @moduledoc """
  @CALLER SurveyLive
  @PARENT_LV SurveyLive
  """

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_demographic()
     |> assign_changeset()
     |> assign_form()}
  end

  @spec assign_demographic(%{
          :assigns => %{
            :current_user => atom | %{:id => any, optional(any) => any},
            optional(any) => any
          },
          optional(any) => any
        }) :: map
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
    #     "user_id" => "2", # because we had a hidden field
    #     "year_of_birth" => "2005"
    #   }
    # }
    {:noreply, save_demographic(socket, demographic)}
  end

  defp save_demographic(socket, params) do
    case Survey.create_demographic(params) do
      {:ok, demographic} ->
        # it is not up to this form to control what's
        # rendered in SurveyLive!
        # send parent a message, let him deal with it
        send(self(), {:created_demographic, demographic})
        socket

      {:error, %Ecto.Changeset{} = changeset} ->
        assign(socket, :changeset, changeset)
    end
  end
end
