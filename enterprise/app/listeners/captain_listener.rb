class NavigatorListener < BaseListener
  include ::Events::Types

  def conversation_resolved(event)
    conversation = extract_conversation_and_account(event)[0]
    assistant = conversation.inbox.navigator_assistant

    return unless conversation.inbox.navigator_active?

    Navigator::Llm::ContactNotesService.new(assistant, conversation).generate_and_update_notes if assistant.config['feature_memory'].present?
    Navigator::Llm::ConversationFaqService.new(assistant, conversation).generate_and_deduplicate if assistant.config['feature_faq'].present?
  end
end
