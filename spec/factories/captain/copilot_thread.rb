FactoryBot.define do
  factory :navigator_copilot_thread, class: 'CopilotThread' do
    account
    user
    title { Faker::Lorem.sentence }
    assistant { create(:navigator_assistant, account: account) }
  end
end
