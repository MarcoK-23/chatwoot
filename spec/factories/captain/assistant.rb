FactoryBot.define do
  factory :navigator_assistant, class: 'Navigator::Assistant' do
    sequence(:name) { |n| "Assistant #{n}" }
    description { 'Test description' }
    association :account
  end
end
