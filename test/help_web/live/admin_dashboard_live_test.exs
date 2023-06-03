defmodule HelpWeb.AdminDashboardLiveTest do
  # use Help.DataCase, async: true, shared: true
  use HelpWeb.ConnCase
  import Phoenix.LiveViewTest

  alias Help.{Accounts, Survey, Catalog}
  alias HelpWeb.Admin.SurveyResultsLive

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
  @create_demographic_under_18 %{
    gender: "female",
    year_of_birth: DateTime.utc_now().year - 15
  }
  @create_demographic_over_18 %{
    gender: "male",
    year_of_birth: DateTime.utc_now().year - 30
  }

  def product_fixture do
    {:ok, product} = Catalog.create_product(@create_product_attrs)
    product
  end

  def user_fixture(attrs \\ @create_user_attrs) do
    {:ok, user} = Accounts.register_user(attrs)
    user
  end

  def demographic_fixture(user, attrs \\ @create_demographic_under_18) do
    attrs =
      attrs
      |> Map.merge(%{user_id: user.id})

    {:ok, demographic} = Survey.create_demographic(attrs)
    demographic
  end

  def rating_fixture(stars, user, product) do
    {:ok, rating} =
      Survey.create_rating(%{
        stars: stars,
        user_id: user.id,
        product_id: product.id
      })

    rating
  end

  def create_product(_) do
    %{product: product_fixture()}
  end

  def create_user(_) do
    %{user: user_fixture()}
  end

  def create_rating(stars, user, product) do
    %{rating: rating_fixture(stars, user, product)}
  end

  def create_demographic(user) do
    %{demographic: demographic_fixture(user)}
  end

  def create_socket(_) do
    %{socket: %Phoenix.LiveView.Socket{}}
  end

  describe "SurveyResults" do
    setup [
      :register_and_log_in_user,
      :create_product,
      :create_user
    ]

    setup %{user: user, product: product} = socket do
      create_demographic(user)
      create_rating(2, user, product)
      user2 = user_fixture(@create_user_attrs2)
      demographic_fixture(user2, @create_demographic_over_18)
      create_rating(3, user2, product)
      [user2: user2]
    end

    test "it filters by age group", %{conn: conn} do
      {:ok, live, _html} = live(conn, "/admin-dashboard")
      params = %{"age_group_filter_name" => "under 18"}

      assert live
             # |> open_browser()
             |> element("#age-group-form")
             |> render_change(params) =~ "<title>2.00</title>"
    end
  end
end
