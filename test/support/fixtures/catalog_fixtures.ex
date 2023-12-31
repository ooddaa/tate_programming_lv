defmodule Help.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Help.Catalog` context.
  """

  @doc """
  Generate a unique product sku.
  """
  # has to be at least 7 digits long
  def unique_product_sku, do: System.unique_integer([:positive]) + 1_000_000

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        sku: unique_product_sku(),
        unit_price: 120.5
      })
      |> Help.Catalog.create_product()

    product
  end
end
