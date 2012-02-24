class CreateSearchParams < ActiveRecord::Migration
  def self.up
    create_table :search_params do |t|
      t.string :name
      t.string :value_str
      t.integer :value_int
      t.integer :search_id
      t.timestamps
    end
  end

  def self.down
    drop_table :search_params
  end

end
