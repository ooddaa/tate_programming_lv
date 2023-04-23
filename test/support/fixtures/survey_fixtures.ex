defmodule Help.SurveyFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Help.Survey` context.
  """

  import Help.AccountsFixtures
  import Help.CatalogFixtures

  @doc """
  Generate a demographic.
  """
  def demographic_fixture(attrs \\ %{}) do
    {:ok, demographic} =
      attrs
      |> Enum.into(%{
        gender: Enum.random(["male", "female", "prefer not to say"]),
        year_of_birth: Enum.random(1900..2005),
        # gender: "alien",
        # year_of_birth: 0,
        user_id: user_fixture().id
      })
      |> Help.Survey.create_demographic()

    demographic
  end

  @doc """
  Generate a rating.
  """
  def rating_fixture(attrs \\ %{}) do
    {:ok, rating} =
      attrs
      |> Enum.into(%{
        # stars: 123,
        stars: Enum.random(1..5),
        user_id: user_fixture().id,
        product_id: product_fixture().id
      })
      |> Help.Survey.create_rating()

    rating
  end
end
