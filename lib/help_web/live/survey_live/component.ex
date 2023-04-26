defmodule HelpWeb.SurveyLive.Component do
  use Phoenix.Component

  attr :content, :string, required: true
  slot :inner_block, required: true

  def hero(assigns) do
    IO.inspect(assigns, label: "assigns")
    # assigns: %{
    #   __changed__: nil,
    #   __given__: %{
    #     __changed__: nil,
    #     content: "Survey",
    #     inner_block: [
    #       %{
    #         __slot__: :inner_block,
    #         inner_block: #Function<1.76646508/2 in HelpWeb.SurveyLive.render/1>
    #       }
    #     ]
    #   },
    #   content: "Survey",
    #   inner_block: [
    #     %{
    #       __slot__: :inner_block,
    #       inner_block: #Function<1.76646508/2 in HelpWeb.SurveyLive.render/1>
    #     }
    #   ]
    # }

    ~H"""
    <h1 class="font-heavy text-3xl">
      <%= @content %>
    </h1>
    <h3>
      <%= render_slot(@inner_block) %>
    </h3>
    <pre>
    <%!-- <%= inspect(assigns) %> --%>
    <% %{ inner_block: [ %{inner_block: block_fn}]} = assigns  %>
    <%= inspect(block_fn.(assigns.__changed__, assigns)) %>
    <%!-- %Phoenix.LiveView.Rendered{static: ["Please fill out our survey"], dynamic: #Function<2.76646508/1 in HelpWeb.SurveyLive.render/1>, fingerprint: 92943875710347754165322807225228694820, root: nil, caller: :not_available} --%>
    </pre>
    """
  end
end
