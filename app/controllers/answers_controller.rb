class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :find_question, only: [:new, :create]
  before_action :find_answer, only: [:show, :edit, :update, :destroy]
  before_action :check_author, only: [:edit, :update, :destroy]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user_id = current_user.id

    respond_to do |format|
      if @answer.save
        format.html { redirect_to question_path(@question), notice: 'Answer created successfully' }
        format.js
      else
        format.html { redirect_to question_path(@question) }
        format.js
      end
    end
  end

  def edit; end

  def update
    @question = @answer.question
    if @answer.update(answer_params)
      redirect_to question_path(@answer.question), notice: 'Answer updated successfully'
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy
    redirect_to @answer.question, notice: 'Answer deleted successfully'
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @question = Question.find(params[:question_id])
    @answer = @question.answers.find(params[:id])
  end


  def check_author
    if !current_user&.author?(@answer)
      return redirect_to @answer.question, alert: 'You are not authorized to perform this operation.'
    end
  end

  def answer_params
    params.require(:answer).permit(:body, :user_id)
  end
end
