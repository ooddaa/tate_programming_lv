defmodule Help.Search.SearchSku do
  defstruct [:sku]
  @types %{sku: :integer}

  import Ecto.Changeset

  def changeset(%__MODULE__{} = search, attrs \\ {}) do
    {search, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required(Map.keys(@types))
    |> validate_sku_length()
  end

  defp validate_sku_length(changeset) do
    validate_change(changeset, :sku, fn :sku, sku ->
      if to_string(sku) |> String.length() < 7,
        do: [sku: "SKU must be at least 7 digits long"],
        else: []
    end)
  end
end
