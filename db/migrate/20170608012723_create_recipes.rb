class CreateRecipes < ActiveRecord::Migration[5.1]
  def change
    create_table :recipes do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.timestamps
    end
    add_reference :recipes, :chef, foreign_key: true
    # This is required due to a known SQLite3 issue
    change_column :recipes, :chef_id, :integer, null: false
  end
end
