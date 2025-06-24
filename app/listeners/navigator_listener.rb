class NavigatorListener < BaseListener
  include ::Events::Types

  def conversation_resolved(event)
    conversation = extract_conversation_and_account(event)[0]
    assistant = conversation.inbox.navigator_assistant

    return unless assistant.present?

    # Add any post-conversation processing logic here
    Rails.logger.info("Navigator: Conversation #{conversation.id} resolved for assistant #{assistant.name}")
  end
end 