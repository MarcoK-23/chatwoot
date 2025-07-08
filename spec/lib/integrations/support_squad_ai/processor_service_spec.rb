require 'rails_helper'

RSpec.describe Integrations::SupportSquadAi::ProcessorService do
  subject { described_class.new(hook: hook, event: event) }

  let(:account) { create(:account) }
  let(:hook) { create(:integrations_hook, :support_squad_ai, account: account) }
  let(:expected_headers) { { 'Authorization' => "Bearer #{hook.settings['api_key']}" } }
  let(:support_squad_ai_response) do
    {
      'choices' => [
        {
          'message' => {
            'content' => 'This is a reply from support_squad_ai.'
          }
        }
      ]
    }.to_json
  end
  let!(:conversation) { create(:conversation, account: account) }
  let!(:customer_message) { create(:message, account: account, conversation: conversation, message_type: :incoming, content: 'hello agent') }
  let!(:agent_message) { create(:message, account: account, conversation: conversation, message_type: :outgoing, content: 'hello customer') }
  let!(:summary_prompt) do
    if ChatwootApp.enterprise?
      Rails.root.join('enterprise/lib/enterprise/integrations/support_squad_ai_prompts/summary.txt').read
    else
      'Please summarize the key points from the following conversation between support agents and customer as bullet points for the next ' \
        "support agent looking into the conversation. Reply in the user's language."
    end
  end

  describe '#perform' do
    context 'when event name is rephrase' do
      let(:event) { { 'name' => 'rephrase', 'data' => { 'tone' => 'friendly', 'content' => 'This is a test message' } } }

      it 'returns the rephrased message using the tone in data' do
        request_body = {
          'model' => 'gpt-4o-mini',
          'messages' => [
            {
              'role' => 'system',
              'content' => 'You are a helpful support agent. ' \
                           'Please rephrase the following response. ' \
                           'Ensure that the reply should be in user language.'
            },
            { 'role' => 'user', 'content' => event['data']['content'] }
          ]
        }.to_json

        stub_request(:post, 'https://api.openai.com/v1/chat/completions')
          .with(body: request_body, headers: expected_headers)
          .to_return(status: 200, body: support_squad_ai_response, headers: {})

        result = subject.perform
        expect(result).to eq({ :message => 'This is a reply from support_squad_ai.' })
      end
    end

    context 'when custom API endpoint is provided' do
      let(:custom_endpoint) { 'https://custom-api.openai.com/v1/chat/completions' }
      let(:hook) { create(:integrations_hook, :support_squad_ai, account: account, settings: { 'api_key' => 'test_key', 'api_endpoint' => custom_endpoint }) }
      let(:event) { { 'name' => 'rephrase', 'data' => { 'content' => 'This is a test message' } } }

      it 'uses the custom API endpoint' do
        request_body = {
          'model' => 'gpt-4o-mini',
          'messages' => [
            {
              'role' => 'system',
              'content' => 'You are a helpful support agent. ' \
                           'Please rephrase the following response. ' \
                           'Ensure that the reply should be in user language.'
            },
            { 'role' => 'user', 'content' => event['data']['content'] }
          ]
        }.to_json

        stub_request(:post, custom_endpoint)
          .with(body: request_body, headers: expected_headers)
          .to_return(status: 200, body: support_squad_ai_response, headers: {})

        result = subject.perform
        expect(result).to eq({ :message => 'This is a reply from support_squad_ai.' })
      end
    end

    context 'when event name is reply_suggestion' do
      let(:event) { { 'name' => 'reply_suggestion', 'data' => { 'conversation_display_id' => conversation.display_id } } }

      it 'returns the suggested reply' do
        request_body = {
          'model' => 'gpt-4o-mini',
          'messages' => [
            { role: 'system',
              content: Rails.root.join('lib/integrations/support_squad_ai/support_squad_ai_prompts/reply.txt').read },
            { role: 'user', content: customer_message.content },
            { role: 'assistant', content: agent_message.content }
          ]
        }.to_json

        # Update the stub_request with the correct messages order
        stub_request(:post, 'https://api.openai.com/v1/chat/completions')
          .with(body: request_body, headers: expected_headers)
          .to_return(status: 200, body: support_squad_ai_response, headers: {})

        result = subject.perform
        expect(result).to eq({ :message => 'This is a reply from support_squad_ai.' })
      end
    end

    context 'when event name is summarize' do
      let(:event) { { 'name' => 'summarize', 'data' => { 'conversation_display_id' => conversation.display_id } } }

      it 'returns the summarized conversation' do
        request_body = {
          'model' => 'gpt-4o-mini',
          'messages' => [
            { 'role' => 'system', 'content' => summary_prompt },
            { 'role' => 'user', 'content' => conversation_messages }
          ]
        }.to_json

        stub_request(:post, 'https://api.openai.com/v1/chat/completions')
          .with(body: request_body, headers: expected_headers)
          .to_return(status: 200, body: support_squad_ai_response, headers: {})

        result = subject.perform
        expect(result).to eq({ :message => 'This is a reply from support_squad_ai.' })
      end
    end

    context 'when event name is fix_spelling_grammar' do
      let(:event) { { 'name' => 'fix_spelling_grammar', 'data' => { 'content' => 'This is a test' } } }

      it 'returns the corrected text' do
        request_body = {
          'model' => 'gpt-4o-mini',
          'messages' => [
            { 'role' => 'system', 'content' => 'You are a helpful support agent. Please fix the spelling and grammar of the following response. ' \
                                               'Ensure that the reply should be in user language.' },
            { 'role' => 'user', 'content' => event['data']['content'] }
          ]
        }.to_json

        stub_request(:post, 'https://api.openai.com/v1/chat/completions')
          .with(body: request_body, headers: expected_headers)
          .to_return(status: 200, body: support_squad_ai_response, headers: {})

        result = subject.perform
        expect(result).to eq({ :message => 'This is a reply from support_squad_ai.' })
      end
    end

    context 'when event name is shorten' do
      let(:event) { { 'name' => 'shorten', 'data' => { 'content' => 'This is a test' } } }

      it 'returns the shortened text' do
        request_body = {
          'model' => 'gpt-4o-mini',
          'messages' => [
            { 'role' => 'system', 'content' => 'You are a helpful support agent. Please shorten the following response. ' \
                                               'Ensure that the reply should be in user language.' },
            { 'role' => 'user', 'content' => event['data']['content'] }
          ]
        }.to_json

        stub_request(:post, 'https://api.openai.com/v1/chat/completions')
          .with(body: request_body, headers: expected_headers)
          .to_return(status: 200, body: support_squad_ai_response, headers: {})

        result = subject.perform
        expect(result).to eq({ :message => 'This is a reply from support_squad_ai.' })
      end
    end

    context 'when event name is expand' do
      let(:event) { { 'name' => 'expand', 'data' => { 'content' => 'This is a test' } } }

      it 'returns the expanded text' do
        request_body = {
          'model' => 'gpt-4o-mini',
          'messages' => [
            { 'role' => 'system', 'content' => 'You are a helpful support agent. Please expand the following response. ' \
                                               'Ensure that the reply should be in user language.' },
            { 'role' => 'user', 'content' => event['data']['content'] }
          ]
        }.to_json

        stub_request(:post, 'https://api.openai.com/v1/chat/completions')
          .with(body: request_body, headers: expected_headers)
          .to_return(status: 200, body: support_squad_ai_response, headers: {})

        result = subject.perform
        expect(result).to eq({ :message => 'This is a reply from support_squad_ai.' })
      end
    end

    context 'when event name is make_friendly' do
      let(:event) { { 'name' => 'make_friendly', 'data' => { 'content' => 'This is a test' } } }

      it 'returns the friendly text' do
        request_body = {
          'model' => 'gpt-4o-mini',
          'messages' => [
            { 'role' => 'system', 'content' => 'You are a helpful support agent. Please make the following response more friendly. ' \
                                               'Ensure that the reply should be in user language.' },
            { 'role' => 'user', 'content' => event['data']['content'] }
          ]
        }.to_json

        stub_request(:post, 'https://api.openai.com/v1/chat/completions')
          .with(body: request_body, headers: expected_headers)
          .to_return(status: 200, body: support_squad_ai_response, headers: {})

        result = subject.perform
        expect(result).to eq({ :message => 'This is a reply from support_squad_ai.' })
      end
    end

    context 'when event name is make_formal' do
      let(:event) { { 'name' => 'make_formal', 'data' => { 'content' => 'This is a test' } } }

      it 'returns the formal text' do
        request_body = {
          'model' => 'gpt-4o-mini',
          'messages' => [
            { 'role' => 'system', 'content' => 'You are a helpful support agent. Please make the following response more formal. ' \
                                               'Ensure that the reply should be in user language.' },
            { 'role' => 'user', 'content' => event['data']['content'] }
          ]
        }.to_json

        stub_request(:post, 'https://api.openai.com/v1/chat/completions')
          .with(body: request_body, headers: expected_headers)
          .to_return(status: 200, body: support_squad_ai_response, headers: {})

        result = subject.perform
        expect(result).to eq({ :message => 'This is a reply from support_squad_ai.' })
      end
    end

    context 'when event name is simplify' do
      let(:event) { { 'name' => 'simplify', 'data' => { 'content' => 'This is a test' } } }

      it 'returns the simplified text' do
        request_body = {
          'model' => 'gpt-4o-mini',
          'messages' => [
            { 'role' => 'system', 'content' => 'You are a helpful support agent. Please simplify the following response. ' \
                                               'Ensure that the reply should be in user language.' },
            { 'role' => 'user', 'content' => event['data']['content'] }
          ]
        }.to_json

        stub_request(:post, 'https://api.openai.com/v1/chat/completions')
          .with(body: request_body, headers: expected_headers)
          .to_return(status: 200, body: support_squad_ai_response, headers: {})

        result = subject.perform
        expect(result).to eq({ :message => 'This is a reply from support_squad_ai.' })
      end
    end
  end

  private

  def conversation_messages
    "Customer: hello agent\nAgent: hello customer\n"
  end
end 