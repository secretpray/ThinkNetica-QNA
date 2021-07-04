class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: %i(index create)
  before_action :find_answer, only: %i(show update destroy)

  alias current_user current_resource_owner

  def index
    return head :not_found unless @question

    answers = @question.answers.includes(:links, :comments, :user).with_attached_files
    authorize answers

    render json: answers
  end

  def show
    return head :not_found unless @answer

    render json: @answer
  end

  def create
    return head :not_found unless @question
    authorize Answer

    answer = @question.answers.build(answer_params)
    answer.user = current_resource_owner

    if answer.save
      head :created
    else
      render json: { errors: answer.errors }, status: :unprocessable_entity
    end
  end

  def update
    return head :not_found unless @answer
    authorize @answer

    if @answer.update(answer_params)
      head :ok
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    return head :not_found unless @answer
    authorize @answer

    if @answer.destroy!
      head :ok
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  private

  def find_answer
    @answer = Answer.with_attached_files.find_by_id(params[:id])
  # rescue ActiveRecord::RecordNotFound
  #   @answer = nil
  end

  def find_question
    @question = Question.find_by_id(params[:question_id])
  # rescue ActiveRecord::RecordNotFound
  #   @question = nil
  end

  def answer_params
    params.require(:answer).permit(:body, links_attributes: %i[name url])
  end
end
