FactoryBot.define do
  factory :navigator_copilot_message, class: 'CopilotMessage' do
    account
    copilot_thread { association :navigator_copilot_thread }
    message { { content: 'This is a test message' } }
    message_type { 0 }
  end
end
