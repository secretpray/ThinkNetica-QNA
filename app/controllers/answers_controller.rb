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
        # format.html { redirect_to question_path(@question), notice: 'Answer created successfully' }
        flash[:notice] = 'Answer created successfully'
        format.js
      else
        # format.html { redirect_to question_path(@question) }
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
 
    ActionCable.server.broadcast  "questions/#{@answer.question_id}/answers", 
                                  answer_body: @answer.body,
                                  id: @answer.id,
                                  question_id: @answer.question_id,
                                  answers_count: @question.answers.count,
                                  author_id: current_user&.id,
                                  created_at: @answer.created_at,
                                  updated_at: @answer.updated_at,
                                  author_email: @answer.user.email,
                                  links: @answer.links,
                                  files: files_for_broadcast || [],
                                  # question_user_id: @question.user.id,
                                  # best: @answer.best?,
                                  # reward_present: @answer.question.reward&.present? || [], 
                                  # badge_image_attached: @answer.question.reward&.badge_image&.attached? || [],
                                  # reward_badge_image: @answer.question.reward&.badge_image || [],
                                  # rating: @answer.rating,
                                  action: :create

    ActionCable.server.broadcast  'questions_channel', 
                                  id: @answer.question_id,
                                  answers_count: @answer.question.answers.count,
                                  action: :update_badge
  end

  def files_for_broadcast
    @answer.files.map { |file| { id: file.id, filename: file.filename.to_s, url: url_for(file) } }
    # @answer.file&.map { |file| { id: file.id, filename: file.blob.filename, url: rails_blob_path(file) }
  end

  def broadcast_answer_delete
    ActionCable.server.broadcast  "questions/#{@answer.question_id}/answers", 
                                  id: @answer.id, 
                                  author_id: @answer.user.id,
                                  answers_count: @answer.question.answers.count,
                                  action: :destroy
  end

  def broadcast_answer_set_best
    ActionCable.server.broadcast  "questions/#{@answer.question_id}/answers", 
                                  id: @answer.id, 
                                  author_id: current_user&.id,
                                  # author_id: @answer.question.user.id,
                                  is_best: @answer.best?,
                                  action: :set_best
  end
  
end
