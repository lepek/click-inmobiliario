class CreatePois < ActiveRecord::Migration
  def self.up
    create_table :pois do |t|
      t.text :description
      t.string :address
      t.integer :location_id
      t.integer :poi_type_id
      t.timestamps
    end
  end

  def self.down
    drop_table :pois
  end
end