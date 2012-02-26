class AddLatitudeAndLongitudeToPoi < ActiveRecord::Migration
  def self.up
    add_column :pois, :latitude, :float
    add_column :pois, :longitude, :float
  end
  
  def self.down
    remove_column :pois, :latitude
    remove_column :pois, :longitude
  end
end
