class QuestionsController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: %i[show edit update destroy]
  after_action :publish_question, only: :create
  after_action :broadcast_destroy_question, only: :destroy

  def index
    @questions = Question.recent
  end

  def show
    if @question.nil? # quick fix error nil object
      @questions = Question.recent
      render 'index'
    else
      @answer = @question.answers.build
    end
  end

  def new
    @question = Question.new
    authorize Question

    @question.links.build   # (has_many or has_many :through)
    @question.build_reward  # (has_one or belongs_to)
  end

  def create
    @question = current_user.questions.build(question_params)
    authorize @question

    if @question.save
      redirect_to @question, notice: 'Question created successfully'
    else
      render :new
    end
  end

  def edit
    authorize @question
    @question.build_reward unless @question.reward.present?
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
    # @question.destroy

    respond_to do |format|
      if @question.destroy
        format.html { redirect_to root_path }
        format.js
      end
    end
  end

  private

  def find_question
    @question = Question.with_attached_files.find_by_id(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :user_id, files: [],
                              links_attributes: [:id, :name, :url, :_destroy],
                              reward_attributes: [:id, :name, :badge_image, :user_id, :_destroy])
  end

  def publish_question
    return if @question.errors.any?

    SendQuestionJob.perform_later(@question)
  end

  def broadcast_destroy_question
    # destroy from qestions list (index)
    ActionCable.server.broadcast 'questions_channel',
                                  question: @question,
                                  id: @question.id,
                                  action: :delete

    # if deleted question opened in show, redirect page location to root
    ActionCable.server.broadcast  "questions/#{@question.id}/answers",
                                  id: @question.id,
                                  author_id: current_user.id,
                                  action: :delete_question
  end
end
