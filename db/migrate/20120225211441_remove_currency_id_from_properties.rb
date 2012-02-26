class RemoveCurrencyIdFromProperties < ActiveRecord::Migration
  def up
    remove_column :properties, :currency_id
  end

  def down
    add_column :properties, :currency_id, :integer
  end
end
