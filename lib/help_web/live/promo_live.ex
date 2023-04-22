defmodule HelpWeb.PromoLive do
  use HelpWeb, :live_view
  alias Help.Promo.Recipient
  alias Help.Promo

  def mount(_params, _session, socket) do
    {:ok, socket |> assign_recipient() |> assign_changeset() |> assign_form()}
  end

  def assign_recipient(socket) do
    socket
    |> assign(:recipient, %Recipient{})
  end

  def assign_changeset(%{assigns: %{recipient: recipient}} = socket) do
    socket
    |> assign(:changeset, Promo.change_recipient(recipient))
  end

  def assign_form(%{assigns: %{changeset: changeset}} = socket) do
    socket
    |> assign(:form, to_form(changeset))

    # form: %Phoenix.HTML.Form{
    #   source: #Ecto.Changeset<
    #     action: nil,
    #     changes: %{email: "ooddaa@gmail.com", first_name: "oda"},
    #     errors: [],
    #     data: #Help.Promo.Recipient<>,
    #     valid?: true
    #   >,
    #   impl: Phoenix.HTML.FormData.Ecto.Changeset,
    #   id: "recipient",
    #   name: "recipient",
    #   data: %Help.Promo.Recipient{first_name: nil, email: nil},
    #   hidden: [],
    #   params: %{"email" => "ooddaa@gmail.com", "first_name" => "oda"},
    #   errors: [],
    #   options: [method: "post"],
    #   index: nil,
    #   action: nil
    # }
  end

  def handle_event(
        "validate",
        %{"recipient" => recipient_params} = params,
        %{assigns: %{recipient: recipient}} = socket
      ) do
    # IO.inspect(params, label: "validate: params")
    # IO.inspect(socket.assigns.form, label: "form")
    # validate: params: %{
    #   "_target" => ["recipient", "first_name"],
    #   "recipient" => %{
    #     "email" => "ooddaa@gmail.com",
    #     "first_name" => "odasdfsdfsdf"
    #   }
    # }

    changeset =
      recipient
      |> Promo.change_recipient(recipient_params)
      |> Map.put(:action, :validate)

    # |> IO.inspect(label: "changeset")

    {:noreply, socket |> assign(:form, to_form(changeset))}
  end

  def handle_event("save", params, socket) do
    # IO.inspect(params, label: "save: params")
    # save: params: %{
    #   "recipient" => %{
    #     "email" => "ooddaa@gmail.com",
    #     "first_name" => "odasdfsdfsdf"
    #   }
    # }
    :timer.sleep(1000)
    {:noreply, socket}
  end
end
