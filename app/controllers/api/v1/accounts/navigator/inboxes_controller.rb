class Api::V1::Accounts::Navigator::InboxesController < Api::V1::Accounts::BaseController
  before_action :set_assistant

  def index
    @inboxes = @assistant.inboxes
  end

  def create
    inbox = current_account.inboxes.find(params[:inbox_id])
    @assistant.navigator_inboxes.create!(inbox: inbox)
    render json: { message: 'Inbox assigned successfully' }
  end

  def destroy
    inbox = current_account.inboxes.find(params[:inbox_id])
    @assistant.navigator_inboxes.find_by!(inbox: inbox).destroy!
    render json: { message: 'Inbox unassigned successfully' }
  end

  private

  def set_assistant
    @assistant = current_account.navigator_assistants.find(params[:assistant_id])
  end
end 