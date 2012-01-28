class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.text :description
      t.string :code
      t.integer :price
      t.string :address
      t.integer :location_id
      t.integer :type_id
      t.integer :currency_id
      t.integer :operation_id

      t.timestamps
    end
  end
end
