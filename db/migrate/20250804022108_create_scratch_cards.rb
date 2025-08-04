class CreateScratchCards < ActiveRecord::Migration[7.1]
  def change
    create_table :scratch_cards do |t|
      t.string :name, null: false
      t.integer :price_in_cents, null: false, default: 0
      t.text :description
      t.string :image_url
      t.boolean :is_active, default: true

      t.timestamps
    end
    add_index :scratch_cards, :name, unique: true
  end
end
