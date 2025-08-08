# db/migrate/XXXXXXXXXXXXXX_create_tickets.rb
class CreateTickets < ActiveRecord::Migration[7.1]
  def change
    create_table :tickets do |t|
      t.references :user, null: false, foreign_key: true
      t.string :subject
      t.integer :status, default: 0
      t.string :ticket_number

      t.timestamps
    end
    add_index :tickets, :ticket_number, unique: true
  end
end
