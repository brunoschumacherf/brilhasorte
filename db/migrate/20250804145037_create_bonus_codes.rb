class CreateBonusCodes < ActiveRecord::Migration[7.1]
  def change
    create_table :bonus_codes do |t|
      t.string :code, null: false
      t.float :bonus_percentage, null: false, default: 0.0
      t.datetime :expires_at
      t.integer :max_uses, default: -1
      t.integer :uses_count, default: 0, null: false
      t.boolean :is_active, default: true, null: false

      t.timestamps
    end
    add_index :bonus_codes, :code, unique: true
  end
end
