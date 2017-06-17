class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.text :description, null: false
      t.references :chef, foreign_key: true, null: false
      t.references :recipe, foreign_key: true, null: false
      t.timestamps
    end
  end
end
