defmodule HelpWeb.Presence do
  use Phoenix.Presence,
    otp_app: :help,
    pubsub_server: Help.PubSub

  alias HelpWeb.Presence
  @user_activity_topic "user_activity"

  def track_user(pid, product, user_email) do
    IO.inspect(product, label: "🔥 track_user product")
    Presence.track(pid, @user_activity_topic, product.name, %{users: [%{email: user_email}]})
  end

  def list_products_and_users do
    Presence.list(@user_activity_topic)
    |> Enum.map(&extract_product_with_users/1)
  end

  defp extract_product_with_users({product_name, %{metas: metas}}) do
    {product_name, users_from_metas_list(metas)}
  end

  defp users_from_metas_list(metas) do
    Enum.map(metas, &users_from_meta_map/1)
    |> List.flatten()
    |> Enum.uniq()
  end

  defp users_from_meta_map(meta_map) do
    get_in(meta_map, [:users])
  end
end
