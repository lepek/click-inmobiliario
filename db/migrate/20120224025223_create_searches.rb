class CreateSearches < ActiveRecord::Migration
  def self.up
    create_table :searches do |t|
      t.string :name
      t.string :value
      t.integer :count

      t.timestamps
    end
  end

  def self.down
    drop_table :searches
  end

end
