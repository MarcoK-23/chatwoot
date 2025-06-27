module Enterprise::Concerns::Inbox
  extend ActiveSupport::Concern

  included do
    has_one :navigator_inbox, dependent: :destroy, class_name: 'NavigatorInbox'
    has_one :navigator_assistant,
            through: :navigator_inbox,
            class_name: 'Navigator::Assistant'
  end
end
