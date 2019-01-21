defmodule Ecto.Integration.Migration do
  use Ecto.Migration

  def up do
    create table(:categories) do
      add(:name, :string)
    end

    create table(:products) do
      add(:category_id, references(:categories))
      add(:name, :string)
    end

    execute("""
    CREATE MATERIALIZED VIEW catalog AS
      SELECT c.*, count(p.id) AS product_count
      FROM categories c
      LEFT JOIN products p ON c.id = p.category_id
      GROUP BY c.id
    ;
    """)
  end

  def down do
    execute("DROP MATERIALIZED VIEW IF EXISTS catalog;")

    drop(table(:products))

    drop(table(:categories))
  end
end
