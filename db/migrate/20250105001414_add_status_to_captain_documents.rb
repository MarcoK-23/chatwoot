class AddStatusToNavigatorDocuments < ActiveRecord::Migration[7.0]
  def change
    add_column :navigator_documents, :status, :integer, null: false, default: 0
    add_index :navigator_documents, :status
  end
end
