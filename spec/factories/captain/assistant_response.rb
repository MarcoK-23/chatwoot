FactoryBot.define do
  factory :navigator_assistant_response, class: 'Navigator::AssistantResponse' do
    association :assistant, factory: :navigator_assistant
    association :account
    sequence(:question) { |n| "Test question #{n}?" }
    sequence(:answer) { |n| "Test answer #{n}" }
    embedding { Array.new(1536) { rand(-1.0..1.0) } }

    trait :with_document do
      association :document, factory: :navigator_document
    end
  end
end
