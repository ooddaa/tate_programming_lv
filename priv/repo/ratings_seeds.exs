import Ecto.Query
alias Help.Accounts.User
alias Help.Catalog.Product
alias Help.{Repo, Survey}

user_ids = Repo.all(from u in User, select: u.id)
product_ids = Repo.all(from p in Product, select: p.id)
stars = 1..5

for uid <- user_ids, pid <- product_ids do

  Survey.create_rating(%{
    user_id: uid,
    product_id: pid,
    stars: Enum.random(stars)
  })
end
