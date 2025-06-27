class RemoveNotNullFromNavigatorDocuments < ActiveRecord::Migration[7.0]
  def change
    change_column_null :navigator_documents, :name, true
  end
end
