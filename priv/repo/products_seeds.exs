alias Help.Catalog

for name <- ~w(Tool Mastodon BJJ Quake Gibson Elixir) do
  Catalog.create_product(%{
    description: Enum.random(~w(foo bar baz lol)),
    name: name,
    sku: Enum.random(1..1000),
    unit_price: Enum.random(1..100) * 1.0
  })
end
