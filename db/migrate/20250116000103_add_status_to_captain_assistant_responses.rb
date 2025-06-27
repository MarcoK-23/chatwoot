class AddStatusToNavigatorAssistantResponses < ActiveRecord::Migration[7.0]
  def change
    add_column :navigator_assistant_responses, :status, :integer, default: 1, null: false
    add_index :navigator_assistant_responses, :status
  end
end
