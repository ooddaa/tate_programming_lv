defmodule Help.Search do
  alias Help.Search.SearchSku

  def change_search_sku(%SearchSku{} = search, attrs \\ %{}) do
    SearchSku.changeset(search, attrs)
  end
end
