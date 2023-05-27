import Ecto.Query
alias Help.Accounts.User
alias Help.{Repo, Survey}

user_ids = Repo.all(from u in User, select: u.id)
genders = ["male", "female"]
years = 1950..2023

for uid <- user_ids do
  Survey.create_demographic(%{
    user_id: uid,
    gender: Enum.random(genders),
    year_of_birth: Enum.random(years)
  })
end
