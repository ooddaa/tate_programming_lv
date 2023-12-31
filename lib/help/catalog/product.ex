defmodule Help.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset
  alias Help.Survey.Rating

  schema "products" do
    field :description, :string
    field :name, :string
    field :sku, :integer
    field :unit_price, :float
    field :image_upload, :string

    has_many :ratings, Rating
    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :unit_price, :sku, :image_upload])
    |> validate_required([:name, :description, :unit_price, :sku])
    |> validate_min_price()
    |> unique_constraint(:sku)
  end

  @doc false
  def change_unit_price(product, new_price) do
    product
    |> Ecto.Changeset.change(unit_price: new_price)
  end

  defp no_change(product), do: Ecto.Changeset.change(product)

  @doc false
  def increment_unit_price(product, increment) do
    if increment > 0 do
      change_unit_price(product, product.unit_price + increment)
    else
      no_change(product)
    end
  end

  def decrement_unit_price(product, decrement) do
    if decrement > 0 do
      change_unit_price(product, product.unit_price - decrement)
    else
      no_change(product)
    end
  end

  defp validate_min_price(product) do
    # https://hexdocs.pm/ecto/3.8.1/Ecto.Changeset.html#validate_change/3
    validate_change(product, :unit_price, fn :unit_price, price ->
      if price < 0.0, do: [unit_price: "price cannot be negative"], else: []
    end)
  end
end
