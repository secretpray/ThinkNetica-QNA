class AnswersController < ApplicationController
   before_action :find_question, only: %i(new create update)
   before_action :set_answer, only: %i(edit update destroy)

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to question_answer_path(@question, @answer), notice: 'Answer created successfully'
    else
      render :new
    end
  end

  def edit; end


 def update
    if @answer.update(answer_params)
      redirect_to question_answer_path(@question, @answer), notice: 'Answer updated successfully'
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy

    redirect_to question_answers_path(@answer.question), notice: 'Answer deleted successfully'
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
