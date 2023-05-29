defmodule HelpWeb.Presence do
  use Phoenix.Presence,
    otp_app: :help,
    pubsub_server: Help.PubSub

  alias Help.Catalog.{Product}
  alias Help.Accounts.{User}
  alias HelpWeb.Presence
  @user_activity_topic "user_activity"
  @survey_takers_topic "survey_takers_activity"

  def track_user(pid, %Product{} = product, user_email) do
    # IO.inspect(product, label: "🔥 track_user product")
    Presence.track(pid, @user_activity_topic, product.name, %{users: [%{email: user_email}]})
  end

  def track_user(pid, %User{} = user, username) do
    # IO.inspect(user, label: "🤡 track_user user")
    Presence.track(pid, @survey_takers_topic, user.email, %{users: [%{username: username}]})
  end

  def list_products_and_users do
    Presence.list(@user_activity_topic)
    # |> IO.inspect(label: "🦞 list_products_and_users before:")
    |> Enum.map(&extract_product_with_users/1)

    # |> IO.inspect(label: "🦞 list_products_and_users after:")
    # list_products_and_users: [{"Mastodon", [%{email: "ooddaa@gmail.com"}]}]
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

  def list_survey_takers do
    Presence.list(@survey_takers_topic)
    # |> IO.inspect(label: "🦞 list_survey_takers before:")

    # 🦞 list_survey_takers before:: %{
    #   "ooddaa@gmail.com" => %{
    #     metas: [%{phx_ref: "F2Ooclij-SIAgAeG", users: [%{username: "oda"}]}]
    #   }
    # }
    |> Enum.map(&extract_survey_takers/1)

    # |> IO.inspect(label: "🦞 list_survey_takers after:")

    # 🦞 list_survey_takers after:: [{"ooddaa@gmail.com", [nil]}]
  end

  defp extract_survey_takers({email, %{metas: metas}}) do
    {email, usernames_from_users_list(metas)}
  end

  defp usernames_from_users_list(metas) do
    Enum.map(metas, &usernames_from_meta_map/1)
    |> List.flatten()
    |> Enum.uniq()
  end

  defp usernames_from_meta_map(meta_map) do
    get_in(meta_map, [:users])
  end
end
