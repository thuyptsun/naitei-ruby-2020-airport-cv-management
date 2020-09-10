class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.references :sender, index: true, foreign_key: {to_table: :users}
      t.references :receiver, index: true, foreign_key: {to_table: :users}
      t.integer :message
      t.references :job_application, null: false, foreign_key: true

      t.timestamps
    end
  end
end
