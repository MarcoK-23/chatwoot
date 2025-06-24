FactoryBot.define do
  factory :navigator_assistant, class: 'Navigator::Assistant' do
    name { 'Test Navigator Assistant' }
    description { 'A test Navigator AI assistant' }
    config { { product_name: 'Test Product' } }
    association :account
  end
end 