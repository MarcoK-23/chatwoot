require 'rails_helper'

RSpec.describe Account::ConversationsResolutionSchedulerJob, type: :job do
  let(:account) { create(:account) }
  let(:assistant) { create(:navigator_assistant, account: account) }

  describe '#perform - navigator resolutions' do
    context 'when handling different inbox types' do
      let!(:regular_inbox) { create(:inbox, account: account) }
      let!(:email_inbox) { create(:inbox, :with_email, account: account) }

      before do
        create(:navigator_inbox, navigator_assistant: assistant, inbox: regular_inbox)
        create(:navigator_inbox, navigator_assistant: assistant, inbox: email_inbox)
      end

      it 'enqueues resolution jobs only for non-email inboxes with navigator enabled' do
        expect do
          described_class.perform_now
        end.to have_enqueued_job(Navigator::InboxPendingConversationsResolutionJob)
          .with(regular_inbox)
          .exactly(:once)
      end

      it 'does not enqueue resolution jobs for email inboxes even with navigator enabled' do
        expect do
          described_class.perform_now
        end.not_to have_enqueued_job(Navigator::InboxPendingConversationsResolutionJob)
          .with(email_inbox)
      end
    end

    context 'when inbox has no navigator enabled' do
      let!(:inbox_without_navigator) { create(:inbox, account: create(:account)) }

      it 'does not enqueue resolution jobs' do
        expect do
          described_class.perform_now
        end.not_to have_enqueued_job(Navigator::InboxPendingConversationsResolutionJob)
          .with(inbox_without_navigator)
      end
    end
  end
end
