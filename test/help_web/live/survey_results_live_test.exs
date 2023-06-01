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
    gender: "male",
    year_of_birth: DateTime.utc_now().year - 25
  }
  @create_demographic_attrs2 %{
    gender: "female",
    year_of_birth: DateTime.utc_now().year - 18
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

    # setup do
    # setup %{user: user} = socket do
    #   create_demographic(user)
    #   user2 = user_fixture(@create_user_attrs2)
    #   demographic_fixture(user2, @create_demographic_attrs2)
    #   [user2: user2]
    # end

    test "no ratings", %{socket: socket} do
      socket =
        socket
        |> SurveyResultsLive.assign_gender_filter()
        |> SurveyResultsLive.assign_age_group_filter()
        |> SurveyResultsLive.assign_products_with_average_ratings()

      assert socket.assigns.products_with_average_ratings == [{"product_name", 0}]
    end
  end
end
