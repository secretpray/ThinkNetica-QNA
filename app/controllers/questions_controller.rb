class QuestionsController < ApplicationController
  include Voted
  
  before_action :authenticate_user!, except: %i(index show)
  before_action :find_question, only: %i[show edit update destroy]

  def index
    @questions = policy_scope(Question.all)
  end

  def show
    @answer = @question.answers.build
  end

  def new
    @question = Question.new
    authorize Question
    @question.links.build   # (has_many or has_many :through)
    @question.build_reward  # (has_one or belongs_to)
  end

  def create
    @question = current_user.questions.build(question_params)
    authorize @question

    if @question.save
      redirect_to @question, notice: 'Question created successfully'
    else
      render :new
    end
  end

  def edit
    authorize @question
    @question.build_reward unless @question.reward.present?
  end

  def update
    authorize @question
 
    if @question.update(question_params)
      redirect_to @question, notice: 'Question updated successfully'
    else
      render :edit
    end
  end

  def destroy
    authorize @question
    @question.destroy
    redirect_to questions_path, notice: 'Question deleted successfully'
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :user_id, 
                                     files: [], links_attributes: [:id, :name, :url, :_destroy],
                                     reward_attributes: [:id, :name, :badge_image, :user_id, :_destroy])
  end
end
