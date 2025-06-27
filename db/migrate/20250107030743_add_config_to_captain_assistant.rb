class AddConfigToNavigatorAssistant < ActiveRecord::Migration[7.0]
  def change
    add_column :navigator_assistants, :config, :jsonb, default: {}, null: false
  end
end
