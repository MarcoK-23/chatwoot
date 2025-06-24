class CreateNavigatorTables < ActiveRecord::Migration[7.0]
  def up
    # Post this migration, the 'vector' extension is mandatory to run the application.
    # If the extension is not installed, the migration will raise an error.
    setup_vector_extension
    create_assistants
    create_documents
    create_assistant_responses
    create_inboxes
  end

  def down
    drop_table :navigator_inboxes if table_exists?(:navigator_inboxes)
    drop_table :navigator_assistant_responses if table_exists?(:navigator_assistant_responses)
    drop_table :navigator_documents if table_exists?(:navigator_documents)
    drop_table :navigator_assistants if table_exists?(:navigator_assistants)
  end

  private

  def setup_vector_extension
    return if extension_enabled?('vector')

    begin
      enable_extension 'vector'
    rescue ActiveRecord::StatementInvalid
      raise StandardError, "Failed to enable 'vector' extension. Read more at https://chwt.app/v4/migration"
    end
  end

  def create_assistants
    create_table :navigator_assistants do |t|
      t.string :name, null: false
      t.bigint :account_id, null: false
      t.string :description
      t.jsonb :config, default: {}, null: false

      t.timestamps
    end

    add_index :navigator_assistants, :account_id
  end

  def create_documents
    create_table :navigator_documents do |t|
      t.string :name
      t.string :external_link, null: false
      t.text :content
      t.integer :status, default: 0, null: false
      t.bigint :assistant_id, null: false
      t.bigint :account_id, null: false

      t.timestamps
    end

    add_index :navigator_documents, :account_id
    add_index :navigator_documents, :assistant_id
    add_index :navigator_documents, [:assistant_id, :external_link], unique: true
    add_index :navigator_documents, :status
  end

  def create_assistant_responses
    create_table :navigator_assistant_responses do |t|
      t.string :question, null: false
      t.text :answer, null: false
      t.vector :embedding, limit: 1536
      t.integer :status, default: 1, null: false
      t.bigint :assistant_id, null: false
      t.bigint :documentable_id
      t.string :documentable_type
      t.bigint :account_id, null: false

      t.timestamps
    end

    add_index :navigator_assistant_responses, :account_id
    add_index :navigator_assistant_responses, :assistant_id
    add_index :navigator_assistant_responses, :status
    add_index :navigator_assistant_responses, [:documentable_id, :documentable_type], name: 'idx_nav_asst_resp_on_documentable'
    add_index :navigator_assistant_responses, :embedding, using: :ivfflat, name: 'vector_idx_navigator_entries_embedding', opclass: :vector_l2_ops
  end

  def create_inboxes
    create_table :navigator_inboxes do |t|
      t.bigint :navigator_assistant_id, null: false
      t.bigint :inbox_id, null: false

      t.timestamps
    end

    add_index :navigator_inboxes, :navigator_assistant_id
    add_index :navigator_inboxes, [:inbox_id, :navigator_assistant_id], unique: true
  end
end 