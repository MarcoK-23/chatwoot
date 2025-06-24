class Integrations::Navigator::ProcessorService < Integrations::BotProcessorService
  pattr_initialize [:event_name!, :hook!, :event_data!]

  private

  def get_response(_session_id, message_content)
    call_navigator(message_content)
  end

  def process_response(message, response)
    if response == 'conversation_handoff'
      message.conversation.bot_handoff!
    else
      create_conversation(message, { content: response })
    end
  end

  def create_conversation(message, content_params)
    return if content_params.blank?

    conversation = message.conversation
    conversation.messages.create!(
      content_params.merge(
        {
          message_type: :outgoing,
          account_id: conversation.account_id,
          inbox_id: conversation.inbox_id
        }
      )
    )
  end

  def call_navigator(message_content)
    assistant = conversation.inbox.navigator_assistant
    return 'No Navigator assistant configured for this inbox' unless assistant

    service = Navigator::Llm::AssistantChatService.new(assistant: assistant)
    service.generate_response(message_content, previous_messages)
  end

  def previous_messages
    previous_messages = []
    conversation.messages.where(message_type: [:outgoing, :incoming]).where(private: false).offset(1).find_each do |message|
      next if message.content_type != 'text'

      role = determine_role(message)
      previous_messages << { role: role, content: message.content }
    end
    previous_messages
  end

  def determine_role(message)
    message.message_type == 'incoming' ? 'user' : 'assistant'
  end
end 