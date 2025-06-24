class Api::V1::Accounts::Navigator::DocumentsController < Api::V1::Accounts::BaseController
  before_action :set_document, only: [:show, :destroy]

  def index
    @documents = current_account.navigator_documents.ordered
    @documents = @documents.for_assistant(params[:assistant_id]) if params[:assistant_id].present?
  end

  def show
    @document
  end

  def create
    @document = current_account.navigator_documents.new(document_params)
    @document.save!
    render json: @document
  end

  def destroy
    @document.destroy!
    head :ok
  end

  private

  def set_document
    @document = current_account.navigator_documents.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:name, :external_link, :assistant_id)
  end
end 