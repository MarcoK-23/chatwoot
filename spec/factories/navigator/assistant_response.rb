factory :navigator_assistant_response, class: 'Navigator::AssistantResponse' do
  association :assistant, factory: :navigator_assistant
  association :account
  question { 'How do I reset my password?' }
  answer { 'You can reset your password by clicking on the "Forgot Password" link on the login page.' }
  status { 'approved' }
end 