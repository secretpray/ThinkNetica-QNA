class AnswersController < ApplicationController
  before_action :authenticate_user!, except: (:show)
  before_action :find_question, only: %i(new create)
  before_action :set_answer, only: %i(show edit update destroy)
  respond_to :html, :json

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user_id = current_user.id

    respond_to do |format|
      if @answer.save
        format.html { redirect_to question_path(@question), notice: 'Answer created successfully' }
        format.json { render :show, status: :created, location: @answer }
      else
        format.html { redirect_to question_path(@question) }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
        flash[:alert] = @answer.errors.full_messages.join(', ')
        # binding.pry
      end
    end
  end

  def edit; end

  def update
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

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :user_id)
  end
end
