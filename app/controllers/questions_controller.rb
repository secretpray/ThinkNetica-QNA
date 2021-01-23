class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i(index show)
  before_action :find_question, only: %i[show edit update destroy]

  def index
    @questions = policy_scope(Question.all)
  end

  def show; end

  def new
    @question = Question.new
    authorize Question
  end

  def create
    @question = Question.new(question_params)
    authorize @question
    @question.user_id = current_user.id

    if @question.save
      redirect_to @question, notice: 'Question created successfully'
    else
      render :new
    end
  end

  def edit
    authorize @question
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
    params.require(:question).permit(:title, :body, :user_id, files: [])
  end
end
