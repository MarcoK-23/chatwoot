factory :navigator_document, class: 'Navigator::Document' do
  name { 'Test Document' }
  external_link { 'https://example.com/test-document' }
  content { 'This is test content for the document.' }
  status { 'available' }
  association :assistant, factory: :navigator_assistant
  association :account
end 