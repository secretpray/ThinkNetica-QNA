class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: %i(index create)
  before_action :find_answer, only: %i(show update destroy)

  def index
    answers = @question.answers.includes(:links, :comments, :user).with_attached_files
    authorize answers

    render json: answers
  end

  def show
    render json: @answer
  end

  def create
    authorize Answer

    answer = @question.answers.build(answer_params)
    answer.user = current_resource_owner

    if answer.save
      render json: @answer
    else
      render json: { errors: answer.errors }, status: :unprocessable_entity
    end
  end

  def update
    authorize @answer

    if @answer.update(answer_params)
      head :ok
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    # return head :not_found unless @answer
    authorize @answer

    if @answer.destroy!
      head :ok
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  private

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
    # @answer = Answer.with_attached_files.find_by_id(params[:id])
  # rescue ActiveRecord::RecordNotFound
  #   @answer = nil
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, links_attributes: %i[name url])
  end
end
