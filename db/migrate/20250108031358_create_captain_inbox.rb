class CreateNavigatorInbox < ActiveRecord::Migration[7.0]
  def change
    create_table :navigator_inboxes do |t|
      t.references :navigator_assistant, null: false
      t.references :inbox, null: false
      t.timestamps
    end

    add_index :navigator_inboxes, [:navigator_assistant_id, :inbox_id], unique: true
  end
end
