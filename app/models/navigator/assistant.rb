# == Schema Information
#
# Table name: navigator_assistants
#
#  id          :bigint           not null, primary key
#  config      :jsonb            not null
#  description :string
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :bigint           not null
#
# Indexes
#
#  index_navigator_assistants_on_account_id  (account_id)
#
class Navigator::Assistant < ApplicationRecord
  include Avatarable

  self.table_name = 'navigator_assistants'

  belongs_to :account
  has_many :documents, class_name: 'Navigator::Document', dependent: :destroy_async
  has_many :responses, class_name: 'Navigator::AssistantResponse', dependent: :destroy_async
  has_many :navigator_inboxes,
           class_name: 'NavigatorInbox',
           foreign_key: :navigator_assistant_id,
           dependent: :destroy_async
  has_many :inboxes,
           through: :navigator_inboxes
  has_many :messages, as: :sender, dependent: :nullify

  validates :name, presence: true
  validates :description, presence: true
  validates :account_id, presence: true

  scope :ordered, -> { order(created_at: :desc) }
  scope :for_account, ->(account_id) { where(account_id: account_id) }

  def available_name
    name
  end

  def push_event_data
    {
      id: id,
      name: name,
      avatar_url: avatar_url.presence || default_avatar_url,
      description: description,
      created_at: created_at,
      updated_at: updated_at,
      type: 'navigator_assistant'
    }
  end

  def webhook_data
    {
      id: id,
      name: name,
      avatar_url: avatar_url.presence || default_avatar_url,
      description: description,
      created_at: created_at,
      updated_at: updated_at,
      type: 'navigator_assistant'
    }
  end

  private

  def default_avatar_url
    "#{ENV.fetch('FRONTEND_URL', nil)}/assets/images/dashboard/navigator/logo.svg"
  end
end 