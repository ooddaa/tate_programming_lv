defmodule Help.EmployersTest do
  use Help.DataCase

  alias Help.Employers

  describe "companies" do
    alias Help.Employers.Company

    import Help.EmployersFixtures

    @invalid_attrs %{name: nil, number: nil}

    test "list_companies/0 returns all companies" do
      company = company_fixture()
      assert Employers.list_companies() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Employers.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      valid_attrs = %{name: "some name", number: "some number"}

      assert {:ok, %Company{} = company} = Employers.create_company(valid_attrs)
      assert company.name == "some name"
      assert company.number == "some number"
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Employers.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()
      update_attrs = %{name: "some updated name", number: "some updated number"}

      assert {:ok, %Company{} = company} = Employers.update_company(company, update_attrs)
      assert company.name == "some updated name"
      assert company.number == "some updated number"
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()
      assert {:error, %Ecto.Changeset{}} = Employers.update_company(company, @invalid_attrs)
      assert company == Employers.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Employers.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Employers.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Employers.change_company(company)
    end
  end
end
