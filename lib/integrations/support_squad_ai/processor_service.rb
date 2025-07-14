class Integrations::SupportSquadAi::ProcessorService < Integrations::SupportSquadAiBaseService
  def rephrase_message
    system_content = 'You are a helpful support agent. ' \
                     'Please rephrase the following response. ' \
                     'Ensure that the reply should be in user language.'
    make_api_call(build_api_call_body(system_content))
  end

  def summarize_message
    # Get the entire conversation content
    conversation_content = conversation_messages
    
    # Create simple instruction for summary
    instruction = "Please summarize this conversation."
    
    # Build the API request body
    api_body = {
      model: GPT_MODEL,
      messages: [
        { role: 'system', content: instruction },
        { role: 'user', content: conversation_content }
      ]
    }.to_json
    
    # Log the full payload
    payload = {
      instruction: instruction,
      conversation_content: conversation_content,
      event_type: 'summarize',
      conversation_id: conversation.id,
      timestamp: Time.current,
      api_body: api_body
    }
    
    Rails.logger.info("SupportSquadAI Summarize Request - Full Payload: #{payload.to_json}")
    
    # Make the actual API call to the configured endpoint
    make_api_call(api_body)
  end

  def reply_suggestion_message
    # Get the entire conversation content
    conversation_content = conversation_messages
    
    # Create simple instruction for reply suggestion
    instruction = "Please suggest a reply to this conversation."
    
    # Build the API request body
    api_body = {
      model: GPT_MODEL,
      messages: [
        { role: 'system', content: instruction },
        { role: 'user', content: conversation_content }
      ]
    }.to_json
    
    # Log the full payload
    payload = {
      instruction: instruction,
      conversation_content: conversation_content,
      event_type: 'reply_suggestion',
      conversation_id: conversation.id,
      timestamp: Time.current,
      api_body: api_body
    }
    
    Rails.logger.info("SupportSquadAI Reply Suggestion Request - Full Payload: #{payload.to_json}")
    
    # Make the actual API call to the configured endpoint
    make_api_call(api_body)
  end

  def fix_spelling_grammar_message
    system_content = 'You are a helpful support agent. Please fix the spelling and grammar of the following response. ' \
                     'Ensure that the reply should be in user language.'
    make_api_call(build_api_call_body(system_content))
  end

  def shorten_message
    system_content = 'You are a helpful support agent. Please shorten the following response. ' \
                     'Ensure that the reply should be in user language.'
    make_api_call(build_api_call_body(system_content))
  end

  def expand_message
    system_content = 'You are a helpful support agent. Please expand the following response. ' \
                     'Ensure that the reply should be in user language.'
    make_api_call(build_api_call_body(system_content))
  end

  def make_friendly_message
    system_content = 'You are a helpful support agent. Please make the following response more friendly. ' \
                     'Ensure that the reply should be in user language.'
    make_api_call(build_api_call_body(system_content))
  end

  def make_formal_message
    system_content = 'You are a helpful support agent. Please make the following response more formal. ' \
                     'Ensure that the reply should be in user language.'
    make_api_call(build_api_call_body(system_content))
  end

  def simplify_message
    system_content = 'You are a helpful support agent. Please simplify the following response. ' \
                     'Ensure that the reply should be in user language.'
    make_api_call(build_api_call_body(system_content))
  end

  private

  def prompt_from_file(file_name, enterprise: false)
    path = enterprise ? 'enterprise/lib/enterprise/integrations/support_squad_ai_prompts' : 'lib/integrations/support_squad_ai/support_squad_ai_prompts'
    Rails.root.join(path, "#{file_name}.txt").read
  end

  def build_api_call_body(system_content, user_content = event['data']['content'])
    {
      model: GPT_MODEL,
      messages: [
        { role: 'system', content: system_content },
        { role: 'user', content: user_content }
      ]
    }.to_json
  end

  def build_api_call_body_with_messages(system_content, messages)
    {
      model: GPT_MODEL,
      messages: [
        { role: 'system', content: system_content },
        *messages
      ]
    }.to_json
  end

  def conversation_messages(in_array_format: false)
    messages = init_messages_body(in_array_format)

    add_messages_until_token_limit(conversation, messages, in_array_format)
  end

  def add_messages_until_token_limit(conversation, messages, in_array_format, start_from = 0)
    character_count = start_from
    conversation.messages.where(message_type: [:incoming, :outgoing]).where(private: false).reorder('id desc').each do |message|
      character_count, message_added = add_message_if_within_limit(character_count, message, messages, in_array_format)
      break unless message_added
    end
    messages
  end

  def add_message_if_within_limit(character_count, message, messages, in_array_format)
    if valid_message?(message, character_count)
      add_message_to_list(message, messages, in_array_format)
      character_count += message.content.length
      [character_count, true]
    else
      [character_count, false]
    end
  end

  def valid_message?(message, character_count)
    message.content.present? && character_count + message.content.length <= TOKEN_LIMIT
  end

  def add_message_to_list(message, messages, in_array_format)
    formatted_message = format_message(message, in_array_format)
    messages.prepend(formatted_message)
  end

  def init_messages_body(in_array_format)
    in_array_format ? [] : ''
  end

  def format_message(message, in_array_format)
    if in_array_format
      {
        role: message.outgoing? ? 'assistant' : 'user',
        content: message.content
      }
    else
      "#{message.outgoing? ? 'Agent' : 'Customer'}: #{message.content}\n"
    end
  end
end

# Load enterprise extensions if available
if ChatwootApp.enterprise?
  Integrations::SupportSquadAi::ProcessorService.prepend_mod_with('Integrations::SupportSquadAiProcessorService')
end 