defmodule HelpWeb.SurveyResultsLiveTest do
  # , async: true, shared_conn: true
  use Help.DataCase
  # use HelpWeb.ConnCase
  alias HelpWeb.Admin.SurveyResultsLive

  describe "socket state" do
    # IO.inspect("🔥 socket state")

    setup [
      :create_user,
      :create_product,
      :create_socket
      # :register_and_log_in_user
    ]

    setup %{user: user} = socket do
      create_demographic(user)
      user2 = user_fixture(@create_user_attrs2)
      demographic_fixture(user2, @create_demographic_attrs2)
      [user2: user2]
    end

    test "no ratings", %{socket: socket} do
      socket
      |> SurveyResultsLive.assign_gender_filter()
      |> SurveyResultsLive.assign_age_group_filter()
      |> SurveyResultsLive.assign_products_with_average_ratings()
      |> assert_keys(:products_with_average_ratings, [{"product_name", 0}])
    end

    test "ratings are filtered by age group", %{
      socket: socket,
      user: user,
      user2: user2,
      product: product
    } do
      create_rating(2, user, product)
      create_rating(5, user2, product)

      # sets to "all" by default
      socket
      |> SurveyResultsLive.assign_age_group_filter()
      |> assert_keys(:age_group_filter, "all")
      # if filter has been set, does not reset to "all" by default
      |> update_socket(:age_group_filter, "under 18")
      |> SurveyResultsLive.assign_age_group_filter()
      |> assert_keys(:age_group_filter, "under 18")
      # check avg ratings for under 18s - which is user with 2
      |> SurveyResultsLive.assign_gender_filter()
      |> SurveyResultsLive.assign_products_with_average_ratings()
      |> assert_keys(:products_with_average_ratings, [{"product_name", 2.0}])
    end

    defp update_socket(socket, key, value) do
      %{socket | assigns: Map.merge(socket.assigns, Map.new([{key, value}]))}
    end

    defp assert_keys(socket, key, value) do
      assert socket.assigns[key] == value
      socket
    end
  end
end
