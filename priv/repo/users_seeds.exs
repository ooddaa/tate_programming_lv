alias Help.Accounts.User
alias Help.{Accounts}

for i <- 1..100 do
  Accounts.register_user(%{
    email: "user#{i}@whatever.com",
    username: "user#{i}",
    password: "userpassword#{i}",
  })
end
