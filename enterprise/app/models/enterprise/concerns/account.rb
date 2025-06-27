module Enterprise::Concerns::Account
  extend ActiveSupport::Concern

  included do
    has_many :sla_policies, dependent: :destroy_async
    has_many :applied_slas, dependent: :destroy_async
    has_many :custom_roles, dependent: :destroy_async

    has_many :navigator_assistants, dependent: :destroy_async, class_name: 'Navigator::Assistant'
    has_many :navigator_assistant_responses, dependent: :destroy_async, class_name: 'Navigator::AssistantResponse'
    has_many :navigator_documents, dependent: :destroy_async, class_name: 'Navigator::Document'

    has_many :copilot_threads, dependent: :destroy_async
  end
end
