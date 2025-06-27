class Api::V1::Accounts::Navigator::AssistantsController < Api::V1::Accounts::BaseController
  before_action :set_assistant, only: [:show, :update, :destroy]

  def index
    @assistants = current_account.navigator_assistants.ordered
    render json: {
      payload: @assistants.map(&:push_event_data),
      meta: {
        total_count: @assistants.count,
        page: 1
      }
    }
  end

  def show
    render json: @assistant.push_event_data
  end

  def create
    @assistant = current_account.navigator_assistants.new(assistant_params)
    @assistant.save!
    render json: @assistant.push_event_data
  end

  def update
    @assistant.update!(assistant_params)
    render json: @assistant.push_event_data
  end

  def destroy
    @assistant.destroy!
    head :ok
  end

  def playground
    @assistant = current_account.navigator_assistants.find(params[:id])
    # Add playground logic here
    render json: { message: 'Playground feature coming soon!' }
  end

  private

  def set_assistant
    @assistant = current_account.navigator_assistants.find(params[:id])
  end

  def assistant_params
    params.require(:assistant).permit(:name, :description, config: {})
  end
end 