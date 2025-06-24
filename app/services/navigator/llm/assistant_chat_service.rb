require 'openai'

class Navigator::Llm::AssistantChatService < Llm::BaseOpenAiService
  def initialize(assistant: nil)
    super()
    @assistant = assistant
    @messages = [system_message]
    @response = ''
  end

  def generate_response(input, previous_messages = [], role = 'user')
    @messages += previous_messages
    @messages << { role: role, content: input } if input.present?
    request_chat_completion
  end

  private

  def system_message
    {
      role: 'system',
      content: "You are #{@assistant.name}, a helpful AI assistant. #{@assistant.description}"
    }
  end

  def request_chat_completion
    response = @client.chat(
      parameters: {
        model: 'gpt-4o-mini',
        messages: @messages,
        temperature: 0.7,
        max_tokens: 1000
      }
    )
    response.dig('choices', 0, 'message', 'content')
  end
end 