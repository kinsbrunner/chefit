class CreateChefs < ActiveRecord::Migration[5.1]
  def change
    create_table :chefs do |t|
      t.string :chefname, null: false
      t.string :email, null: false
      t.timestamps
    end
  end
end