class QuestionsController < ApplicationController
  before_action :find_question, only: %i(show edit update destroy)

  def index
    @questions = Question.order(created_at: :desc)
  end

  def show; end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)

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

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
