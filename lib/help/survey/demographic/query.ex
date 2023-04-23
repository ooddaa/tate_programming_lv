defmodule Help.Survey.Demographic.Query do
  import Ecto.Query
  alias Help.Survey.Demographic

  def base, do: Demographic

  def for_user(query \\ base(), user) do
    # why is it 'query' and not a 'table'?
    query
    |> where([d], d.user_id == ^user.id)
  end
end
