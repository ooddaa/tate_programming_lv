defmodule Help.Survey.Rating.Query do
  import Ecto.Query

  alias Help.Survey.Rating

  def base, do: Rating

  def preload_user(user) do
    base()
    |> for_user(user)
  end

  @spec for_user(any, atom | %{:id => any, optional(any) => any}) :: Ecto.Query.t()
  def for_user(query, user) do
    query
    |> where([r], r.user_id == ^user.id)
  end
end
