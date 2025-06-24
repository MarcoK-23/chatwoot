require 'rails_helper'

RSpec.describe Api::V1::Accounts::Navigator::AssistantsController, type: :controller do
  let(:account) { create(:account) }
  let(:user) { create(:user, account: account) }
  let(:assistant) { create(:navigator_assistant, account: account) }

  before do
    sign_in(user)
  end

  describe 'GET #index' do
    it 'returns a list of navigator assistants' do
      assistant # Create the assistant
      get :index, params: { account_id: account.id }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to be_an(Array)
    end
  end

  describe 'POST #create' do
    it 'creates a new navigator assistant' do
      post :create, params: {
        account_id: account.id,
        assistant: {
          name: 'New Assistant',
          description: 'A new Navigator assistant'
        }
      }
      expect(response).to have_http_status(:success)
      expect(account.navigator_assistants.count).to eq(1)
    end
  end

  describe 'GET #show' do
    it 'returns the navigator assistant' do
      get :show, params: { account_id: account.id, id: assistant.id }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['id']).to eq(assistant.id)
    end
  end
end 