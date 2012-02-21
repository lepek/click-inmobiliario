class AddFavoritesTable < ActiveRecord::Migration
  def up
    create_table :favorites do |t|
      t.references :property, :user
    end
    add_index :favorites, :property_id
    add_index :favorites, :user_id    
  end

  def down
    drop_table :favorites
  end
end
