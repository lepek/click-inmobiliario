class AddImpressionsCountToProperties < ActiveRecord::Migration
  def up
    add_column :properties, :impressions_count, :integer
  end

  def down
    remove_column :properties, :impressions_count
  end
end
