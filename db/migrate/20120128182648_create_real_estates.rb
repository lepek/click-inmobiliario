class CreateRealEstates < ActiveRecord::Migration
  def change
    create_table :real_estates do |t|
      t.string :name
      t.string :address
      t.string :email

      t.timestamps
    end
  end
end
