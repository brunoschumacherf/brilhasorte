class CreateAuditLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :audit_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :auditable, polymorphic: true, null: true
      t.string :action, null: false
      t.jsonb :details

      t.timestamps
    end
  end
end
