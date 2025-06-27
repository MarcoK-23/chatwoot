FactoryBot.define do
  factory :navigator_document, class: 'Navigator::Document' do
    name { Faker::File.file_name }
    external_link { Faker::Internet.unique.url }
    content { Faker::Lorem.paragraphs.join("\n\n") }
    association :assistant, factory: :navigator_assistant
    association :account
  end
end
