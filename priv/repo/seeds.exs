# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Help.Repo.insert!(%Help.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Help.{Accounts, Catalog, Survey}

{:ok, user} =
  Accounts.register_user(%{username: "lol", password: "a123456789xyz!", email: "lol@lol.lol"})

{:ok, product} =
  Catalog.create_product(%{
    description: "abc",
    name: "test product",
    sku: 1_234_567,
    unit_price: 1.0
  })

{:ok, demo} = Survey.create_demographic(%{gender: "male", year_of_birth: 2000, user_id: user.id})
{:ok, rating} = Survey.create_rating(%{stars: 5, user_id: user.id, product_id: product.id})
