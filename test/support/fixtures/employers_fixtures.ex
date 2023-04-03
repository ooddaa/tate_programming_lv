defmodule Help.EmployersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Help.Employers` context.
  """

  @doc """
  Generate a company.
  """
  def company_fixture(attrs \\ %{}) do
    {:ok, company} =
      attrs
      |> Enum.into(%{
        name: "some name",
        number: "some number"
      })
      |> Help.Employers.create_company()

    company
  end
end
