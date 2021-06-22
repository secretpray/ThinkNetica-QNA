class AnswersController < ApplicationController
  include Voted
  include Commented
  
  before_action :authenticate_user!, except: :show
  before_action :find_question, only: [:new, :create]
  before_action :find_answer, only: %i[show edit update destroy best]
  after_action :broadcast_answer_create, only: :create
  after_action :broadcast_answer_delete, only: :destroy
  after_action :broadcast_answer_set_best, only: :best

  def show; end

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
        flash[:notice] = 'Answer created successfully'
        format.js
      else
        format.html { redirect_to question_path(@question) }
        format.js
      end
    end
  end

  def edit; end

  def update
    authorize @answer
    @answer.update(answer_params)
  end

  def destroy
    authorize @answer
    @answer.destroy
    flash[:notice] = 'Answer deleted successfully'
  end

  def best
    authorize @answer
    @answer.set_best
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :user_id, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end

  def broadcast_answer_create
    return if @answer.errors.any?
    
    SendAnswerJob.perform_later(@answer, current_user)
  end

  def broadcast_answer_delete
    ActionCable.server.broadcast  "questions/#{@answer.question_id}/answers", 
                                  id: @answer.id, 
                                  author_id: @answer.user.id,
                                  answers_count: @answer.question.answers.count,
                                  action: :destroy
  end

  def broadcast_answer_set_best
    reward_link = 
    if @answer.question.reward && @answer.question.reward&.badge_image&.attached?
      Rails.application.routes.url_helpers.rails_blob_url(@answer.question.reward.badge_image, only_path: true)  # @answer.question.reward&.badge_image.url
    else
      []
    end
    
    ActionCable.server.broadcast  "questions/#{@answer.question_id}/answers", 
                                  id: @answer.id, 
                                  author_id: current_user&.id, # <-> author_id: @answer.question.user.id,
                                  is_best: @answer.best?,
                                  reward_badge_image_link: reward_link,
                                  badge_is_attached: @answer.question.reward&.badge_image&.attached?,
                                  action: :set_best
  end
end
