class AnswersController < ApplicationController
   # before_action :find_question, only: %i(new create)
   # before_action :find_answer, only: %i(edit update destroy)

  def new
    @answer = question.answers.new
  end

  def create
    if answer.save
      redirect_to question_answer_path(question, answer), notice: 'Answer created successfully'
    else
      render :new
    end
  end

  def edit; end


 def update
    if answer.update(answer_params)
      redirect_to question_answer_path(question, answer), notice: 'Answer updated successfully'
    else
      render :edit
    end
  end

  def destroy
    answer.destroy

    redirect_to question_answers_path(question), notice: 'Answer deleted successfully'
  end

  private

  # def find_answer
  #   @answer = Answer.find(params[:id])
  # end

  # def find_question
  #   @question = Question.find(params[:id])
  # end

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :question

  def answers
    @answers ||= question.answers
  end

  helper_method :answers

  def answer
    @answer ||= params[:id].present? ? answers.find(params[:id]) : answers.build(answer_params)
  end

  helper_method :answer

  def answer_params
    params.require(:answer).permit(:body)
  end
end
