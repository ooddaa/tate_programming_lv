defmodule Help.Survey.Rating do
  use Ecto.Schema
  import Ecto.Changeset
  alias Help.Accounts.User
  alias Help.Catalog.Product

  schema "ratings" do
    field :stars, :integer
    # field :user_id, :id
    # field :product_id, :id

    belongs_to :user, User
    belongs_to :product, Product

    timestamps()
  end

  @doc false
  def changeset(rating, attrs) do
    rating
    |> cast(attrs, [:stars, :user_id, :product_id])
    |> validate_required([:stars, :user_id, :product_id])
    |> validate_inclusion(:stars, 1..5)
    # why not [:user_id, :product_id] ??
    |> unique_constraint(:product_id, name: :index_ratings_on_user_products)
  end
end
