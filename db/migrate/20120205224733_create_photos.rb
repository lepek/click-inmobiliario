class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.text :description
      t.string :file
      t.integer :property_id

      t.timestamps
    end
  end
end
