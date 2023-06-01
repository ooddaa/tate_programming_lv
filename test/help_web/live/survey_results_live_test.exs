defmodule HelpWeb.SurveyResultsLiveTest do
  use Help.DataCase
  alias HelpWeb.Admin.SurveyResultsLive
  alias Help.{Accounts, Survey, Catalog}

  @create_product_attrs %{
    description: "product_descr",
    name: "product_name",
    sku: 1,
    unit_price: 1.0
  }
  @create_user_attrs %{
    username: "username",
    password: "usernameusername",
    email: "email@email.com"
  }
  @create_user_attrs2 %{
    username: "username2",
    password: "usernameusername2",
    email: "email2@email.com"
  }
  @create_demographic_attrs %{
    gender: "female",
    year_of_birth: DateTime.utc_now().year - 15
  }
  @create_demographic_attrs2 %{
    gender: "male",
    year_of_birth: DateTime.utc_now().year - 30
  }

  defp product_fixture do
    {:ok, product} = Catalog.create_product(@create_product_attrs)
    product
  end

  defp user_fixture(attrs \\ @create_user_attrs) do
    {:ok, user} = Accounts.register_user(attrs)
    user
  end

  defp demographic_fixture(user, attrs \\ @create_demographic_attrs) do
    attrs =
      attrs
      |> Map.merge(%{user_id: user.id})

    {:ok, demographic} = Survey.create_demographic(attrs)
    demographic
  end

  defp rating_fixture(stars, user, product) do
    {:ok, rating} =
      Survey.create_rating(%{
        stars: stars,
        user_id: user.id,
        product_id: product.id
      })

    rating
  end

  defp create_product(_) do
    %{product: product_fixture()}
  end

  defp create_user(_) do
    %{user: user_fixture()}
  end

  defp create_rating(stars, user, product) do
    %{rating: rating_fixture(stars, user, product)}
  end

  defp create_demographic(user) do
    %{demographic: demographic_fixture(user)}
  end

  defp create_socket(_) do
    %{socket: %Phoenix.LiveView.Socket{}}
  end

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
