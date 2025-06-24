factory :navigator_inbox, class: 'NavigatorInbox' do
  association :navigator_assistant, factory: :navigator_assistant
  association :inbox
end 