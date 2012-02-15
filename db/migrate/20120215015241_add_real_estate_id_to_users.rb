class AddRealEstateIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :real_estate_id, :integer
  end
end
