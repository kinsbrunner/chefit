class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.text :content, null: false
      t.references :chef, null: false
      t.timestamps
    end
  end
end
