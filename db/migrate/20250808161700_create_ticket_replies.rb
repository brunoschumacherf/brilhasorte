class CreateTicketReplies < ActiveRecord::Migration[7.1]
  def change
    create_table :ticket_replies do |t|
      t.references :user, null: false, foreign_key: true
      t.references :ticket, null: false, foreign_key: true
      t.text :message

      t.timestamps
    end
  end
end
