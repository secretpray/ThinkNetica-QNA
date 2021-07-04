class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :find_question, only: %i(show update destroy)

  def index
    @questions = Question.includes(:answers, :links, :comments, :user).with_attached_files
    authorize @questions

    render json: @questions
  end

  def show
    # return head :not_found unless @question
    render json: @question
  end

  def create
    question = current_resource_owner.questions.build(question_params)
    authorize Question

    if question.save
      render json: @answer
    else
      render json: { errors: question.errors }, status: :unprocessable_entity
    end
  end

  def update
    authorize @question

    if @question.update(question_params)
      head :ok
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @question

    if @question.destroy!
      head :ok
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title,
                                     :body,
                                     links_attributes: [:name, :url],
                                     reward_attributes: [:name, :badge_image])
  end
end
