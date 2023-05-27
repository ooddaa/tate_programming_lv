defmodule Help.Survey.Demographic.Query do
  import Ecto.Query
  alias Help.Survey.Demographic

  def base, do: Demographic

  def for_user(query \\ base(), user) do
    query
    |> where([d], d.user_id == ^user.id)
  end

  def filter_by_age_group(query \\ base(), filter) do
    query
    |> apply_age_group_filter(filter)
  end

  defp apply_age_group_filter(query, "under 18") do
    date_max = DateTime.utc_now().year - 18

    query
    |> where([d], d.year_of_birth > ^date_max)
  end

  defp apply_age_group_filter(query, "18 to 25") do
    date_max = DateTime.utc_now().year - 18
    date_min = DateTime.utc_now().year - 25

    query
    |> where([d], d.year_of_birth <= ^date_max and d.year_of_birth > ^date_min)
  end

  defp apply_age_group_filter(query, "25 to 35") do
    date_max = DateTime.utc_now().year - 25
    date_min = DateTime.utc_now().year - 35

    query
    |> where([d], d.year_of_birth <= ^date_max and d.year_of_birth > ^date_min)
  end

  defp apply_age_group_filter(query, "over 35") do
    date_min = DateTime.utc_now().year - 35

    query
    |> where([d], d.year_of_birth < ^date_min)
  end

  defp apply_age_group_filter(query, _) do
    query
  end
end
