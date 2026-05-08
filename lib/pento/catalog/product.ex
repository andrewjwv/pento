defmodule Pento.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pento.Catalog

  schema "products" do
    field :name, :string
    field :description, :string
    field :unit_price, :float
    field :sku, :integer
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs, user_scope) do
    product
    |> cast(attrs, [:name, :description, :unit_price, :sku])
    |> validate_required([:name, :description, :unit_price, :sku])
    |> unique_constraint(:sku)
    |> validate_number(:unit_price, greater_than: 0.0)
    |> put_change(:user_id, user_scope.user.id)
  end

  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :unit_price, :sku])
    |> validate_required([:name, :description, :unit_price, :sku])
    |> unique_constraint(:sku)
    |> validate_number(:unit_price, greater_than: 0.0)
  end
  def discount(product_id,new_price) do
    product = Catalog.get_product!(product_id)
    attrs= %{unit_price: product.unit_price - new_price}
    changeset=
      product
      |> change(attrs)
      |> validate_required([:unit_price])
      |> validate_number(:unit_price, greater_than: 0.0, less_than: product.unit_price)

    if changeset.valid? do
      Catalog.update_product(product, attrs)
    else
      {:error, changeset}
    end
  end

  def change_product(%__MODULE__{} = product, user_scope, attrs \\ %{}) do
    changeset(product, attrs, user_scope)
  end
end
