import Ecto.Query
alias Help.Accounts.User
alias Help.Catalog.Product
alias Help.{Repo, Accounts, Survey}

for i <- 1..43 do
  Accounts.register_user(%{
    email: "user#{i}@whatever.com",
    username: "user#{i}",
    password: "userpassword#{i}",
  })
end

user_ids = Repo.all(from u in User, select: u.id)
product_ids = Repo.all(from p in Product, select: p.id)
genders = ["male", "female"]
years = 1960..2017
stars = 1..5

for uid <- user_ids do
  Survey.create_demographic(%{
    user_id: uid,
    gender: Enum.random(genders),
    year_of_birth: Enum.random(years)
  })
end

for uid <- user_ids, pid <- product_ids do
  Survey.create_rating(%{
    user_id: uid,
    product_id: pid,
    rating: Enum.random(stars)
  })
end
