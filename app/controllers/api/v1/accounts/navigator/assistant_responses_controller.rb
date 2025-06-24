class Api::V1::Accounts::Navigator::AssistantResponsesController < Api::V1::Accounts::BaseController
  before_action :set_response, only: [:show, :update, :destroy]

  def index
    @responses = current_account.navigator_assistant_responses.ordered
    @responses = @responses.by_assistant(params[:assistant_id]) if params[:assistant_id].present?
    @responses = @responses.with_document(params[:document_id]) if params[:document_id].present?
    @responses = @responses.where(status: params[:status]) if params[:status].present?
  end

  def show
    @response
  end

  def create
    @response = current_account.navigator_assistant_responses.new(response_params)
    @response.save!
    render json: @response
  end

  def update
    @response.update!(response_params)
    render json: @response
  end

  def destroy
    @response.destroy!
    head :ok
  end

  private

  def set_response
    @response = current_account.navigator_assistant_responses.find(params[:id])
  end

  def response_params
    params.require(:response).permit(:question, :answer, :assistant_id, :documentable_id, :documentable_type, :status)
  end
end 