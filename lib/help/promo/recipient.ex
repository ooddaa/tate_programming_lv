defmodule Help.Promo.Recipient do
  defstruct [:first_name, :email]
  @types %{first_name: :string, email: :string}

  import Ecto.Changeset

  def changeset(%__MODULE__{} = user, attrs \\ %{}) do
    {user, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required(Map.keys(@types))
    |> validate_length(:first_name, min: 1)
    |> validate_format(:email, ~r/@/)
  end
end
