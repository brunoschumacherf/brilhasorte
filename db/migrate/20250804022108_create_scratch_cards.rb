class CreateScratchCards < ActiveRecord::Migration[7.1]
  def change
    create_table :scratch_cards do |t|
      t.string :name
      t.integer :price_in_cents
      t.text :description
      t.string :image_url
      t.boolean :is_active

      t.timestamps
    end
  end
end
