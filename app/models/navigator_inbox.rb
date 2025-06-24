# == Schema Information
#
# Table name: navigator_inboxes
#
#  id                    :bigint           not null, primary key
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  inbox_id              :bigint           not null
#  navigator_assistant_id :bigint           not null
#
# Indexes
#
#  index_navigator_inboxes_on_inbox_id_and_navigator_assistant_id  (inbox_id,navigator_assistant_id) UNIQUE
#  index_navigator_inboxes_on_navigator_assistant_id               (navigator_assistant_id)
#
class NavigatorInbox < ApplicationRecord
  self.table_name = 'navigator_inboxes'

  belongs_to :navigator_assistant, class_name: 'Navigator::Assistant'
  belongs_to :inbox

  validates :inbox_id, uniqueness: { scope: :navigator_assistant_id }
end 