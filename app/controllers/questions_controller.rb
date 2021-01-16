class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i(index show)
  before_action :find_question, only: %i[show edit update destroy]
  before_action :check_author, only: [:update, :destroy]

  def index
    @questions = Question.all
  end

  def show; end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    @question.user_id = current_user.id

    if @question.save
      redirect_to @question, notice: 'Question created successfully'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @question.update(question_params)
      redirect_to @question, notice: 'Question updated successfully'
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Question deleted successfully'
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def check_author
    if !current_user&.author?(@question)
      return redirect_to questions_path, alert: 'You are not authorized to perform this operation.'
    end
  end

  def question_params
    params.require(:question).permit(:title, :body, :user_id)
  end
end
