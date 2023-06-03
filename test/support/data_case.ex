defmodule Help.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use Help.DataCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Help.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Help.DataCase

      # alias Help.{Accounts, Survey, Catalog}

      # @create_product_attrs %{
      #   description: "product_descr",
      #   name: "product_name",
      #   sku: 1,
      #   unit_price: 1.0
      # }
      # @create_user_attrs %{
      #   username: "username",
      #   password: "usernameusername",
      #   email: "email@email.com"
      # }
      # @create_user_attrs2 %{
      #   username: "username2",
      #   password: "usernameusername2",
      #   email: "email2@email.com"
      # }
      # @create_demographic_attrs %{
      #   gender: "female",
      #   year_of_birth: DateTime.utc_now().year - 15
      # }
      # @create_demographic_attrs2 %{
      #   gender: "male",
      #   year_of_birth: DateTime.utc_now().year - 30
      # }

      # def product_fixture do
      #   {:ok, product} = Catalog.create_product(@create_product_attrs)
      #   product
      # end

      # def user_fixture(attrs \\ @create_user_attrs) do
      #   {:ok, user} = Accounts.register_user(attrs)
      #   user
      # end

      # def demographic_fixture(user, attrs \\ @create_demographic_attrs) do
      #   attrs =
      #     attrs
      #     |> Map.merge(%{user_id: user.id})

      #   {:ok, demographic} = Survey.create_demographic(attrs)
      #   demographic
      # end

      # def rating_fixture(stars, user, product) do
      #   {:ok, rating} =
      #     Survey.create_rating(%{
      #       stars: stars,
      #       user_id: user.id,
      #       product_id: product.id
      #     })

      #   rating
      # end

      # def create_product(_) do
      #   %{product: product_fixture()}
      # end

      # def create_user(_) do
      #   %{user: user_fixture()}
      # end

      # def create_rating(stars, user, product) do
      #   %{rating: rating_fixture(stars, user, product)}
      # end

      # def create_demographic(user) do
      #   %{demographic: demographic_fixture(user)}
      # end

      # def create_socket(_) do
      #   %{socket: %Phoenix.LiveView.Socket{}}
      # end
    end
  end

  setup tags do
    Help.DataCase.setup_sandbox(tags)
    :ok
  end

  @doc """
  Sets up the sandbox based on the test tags.
  """
  def setup_sandbox(tags) do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(Help.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
