class CreateLikes < ActiveRecord::Migration[5.1]
  def change
    create_table :likes do |t|
      t.boolean :like
      t.references :recipe, null: false
      t.references :chef, null: false
      t.timestamps
    end
  end
end
