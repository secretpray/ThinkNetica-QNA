class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :find_question, only: [:new, :create]
  before_action :find_answer, only: [:edit, :update, :destroy]

  def new
    @answer = @question.answers.new
    authorize @answer
  end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user_id = current_user.id
    authorize @answer

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
    authorize @answer
    @answer.update(answer_params)
  end

  def destroy
    authorize @answer
    @answer.destroy
  end

  def best
    @answer = Answer.find(params[:id])
    @question = @answer.question
    authorize @answer

    respond_to do |format|
      if @answer.set_best
        format.js
        flash[:notice] = 'You have marked the best answer to your question'
      else
        format.js
      end
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @question = Question.find(params[:question_id])
    @answer = @question.answers.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :user_id, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end
end
