module Enterprise::Account::ConversationsResolutionSchedulerJob
  def perform
    super

    resolve_navigator_conversations
  end

  private

  def resolve_navigator_conversations
    NavigatorInbox.all.find_each(batch_size: 100) do |navigator_inbox|
      inbox = navigator_inbox.inbox

      next if inbox.email?

      Navigator::InboxPendingConversationsResolutionJob.perform_later(
        inbox
      )
    end
  end
end
