defmodule Ecto.Integration.Migration do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add(:name, :string)
    end

    create table(:products) do
      add(:category_id, references(:categories))
      add(:name, :string)
    end
  end
end
