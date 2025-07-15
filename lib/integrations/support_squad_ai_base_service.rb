class Integrations::SupportSquadAiBaseService
  # gpt-4o-mini supports 128,000 tokens
  # 1 token is approx 4 characters
  # sticking with 120000 to be safe
  # 120000 * 4 = 480,000 characters (rounding off downwards to 400,000 to be safe)
  TOKEN_LIMIT = 400_000
  API_URL = 'https://api.openai.com/v1/chat/completions'.freeze
  GPT_MODEL = ENV.fetch('SUPPORT_SQUAD_AI_GPT_MODEL', 'gpt-4o-mini').freeze

  ALLOWED_EVENT_NAMES = %w[rephrase summarize reply_suggestion fix_spelling_grammar shorten expand make_friendly make_formal simplify].freeze
  CACHEABLE_EVENTS = %w[].freeze

  pattr_initialize [:hook!, :event!]

  def perform
    return nil unless valid_event_name?

    return value_from_cache if value_from_cache.present?

    response = send("#{event_name}_message")
    save_to_cache(response) if response.present?

    response
  end

  private

  def event_name
    event['name']
  end

  def cache_key
    return nil unless event_is_cacheable?

    return nil unless conversation

    # since the value from cache depends on the conversation last_activity_at, it will always be fresh
    format(::Redis::Alfred::SUPPORT_SQUAD_AI_CONVERSATION_KEY, event_name: event_name, conversation_id: conversation.id,
                                                     updated_at: conversation.last_activity_at.to_i)
  end

  def value_from_cache
    return nil unless event_is_cacheable?
    return nil if cache_key.blank?

    deserialize_cached_value(Redis::Alfred.get(cache_key))
  end

  def deserialize_cached_value(value)
    return nil if value.blank?

    JSON.parse(value, symbolize_names: true)
  rescue JSON::ParserError
    # If json parse failed, returning the value as is will fail too
    # since we access the keys as symbols down the line
    # So it's best to return nil
    nil
  end

  def save_to_cache(response)
    return nil unless event_is_cacheable?

    # Serialize to JSON
    # This makes parsing easy when response is a hash
    Redis::Alfred.setex(cache_key, response.to_json)
  end

  def conversation
    @conversation ||= hook.account.conversations.find_by(display_id: event['data']['conversation_display_id'])
  end

  def valid_event_name?
    # self.class::ALLOWED_EVENT_NAMES is way to access ALLOWED_EVENT_NAMES defined in the class hierarchy of the current object.
    # This ensures that if ALLOWED_EVENT_NAMES is updated elsewhere in it's ancestors, we access the latest value.
    self.class::ALLOWED_EVENT_NAMES.include?(event_name)
  end

  def event_is_cacheable?
    # self.class::CACHEABLE_EVENTS is way to access CACHEABLE_EVENTS defined in the class hierarchy of the current object.
    # This ensures that if CACHEABLE_EVENTS is updated elsewhere in it's ancestors, we access the latest value.
    self.class::CACHEABLE_EVENTS.include?(event_name)
  end

  def make_api_call(request_content)
    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{hook.settings['api_key']}"
    }

    # Build the custom request format for Support Squad server
    request_body = {
      request: request_content
    }.to_json

    # Use custom API endpoint if provided, otherwise use default
    base_api_url = hook.settings['api_endpoint'].presence || API_URL
    
    # Extract company_id from the hook settings or use a default
    company_id = hook.settings['company_id'] || 'default'
    
    # Construct the full URL with company_id
    api_url = if base_api_url.include?('/completion')
                # If the endpoint already includes /completion, replace it with the company_id format
                base_api_url.gsub('/completion', "/#{company_id}/completion")
              else
                # Otherwise, append the company_id and completion path
                "#{base_api_url}/#{company_id}/completion"
              end

    Rails.logger.info("SupportSquadAI API request to: #{api_url}")
    Rails.logger.info("SupportSquadAI API request body: #{request_body}")
    
    response = HTTParty.post(api_url, headers: headers, body: request_body)
    Rails.logger.info("SupportSquadAI API response: #{response.body}")

    return { error: response.parsed_response, error_code: response.code } unless response.success?

    # Parse the response from Support Squad server
    # The server should return the AI-generated response directly
    response_text = response.parsed_response
    
    # If the response is a string, use it directly
    if response_text.is_a?(String)
      return { message: response_text }
    end
    
    # If the response is a hash, look for common response fields
    if response_text.is_a?(Hash)
      # Try different possible response formats
      message = response_text['message'] || 
                response_text['response'] || 
                response_text['content'] || 
                response_text['text']
      
      return { message: message } if message.present?
    end

    { message: nil }
  end
end 