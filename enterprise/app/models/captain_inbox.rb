# == Schema Information
#
# Table name: navigator_inboxes
#
#  id                   :bigint           not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  navigator_assistant_id :bigint           not null
#  inbox_id             :bigint           not null
#
# Indexes
#
#  index_navigator_inboxes_on_navigator_assistant_id               (navigator_assistant_id)
#  index_navigator_inboxes_on_navigator_assistant_id_and_inbox_id  (navigator_assistant_id,inbox_id) UNIQUE
#  index_navigator_inboxes_on_inbox_id                           (inbox_id)
#
class NavigatorInbox < ApplicationRecord
  belongs_to :navigator_assistant, class_name: 'Navigator::Assistant'
  belongs_to :inbox

  validates :inbox_id, uniqueness: true
end
