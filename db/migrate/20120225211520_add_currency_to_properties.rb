class AddCurrencyToProperties < ActiveRecord::Migration
  def up
    add_column :properties, :currency, :string
  end

  def down
    remove_column :properties, :currency
  end
end
