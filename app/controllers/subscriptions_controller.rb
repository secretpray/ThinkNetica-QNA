class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: :create
  before_action :find_subscription, only: :destroy

  def create
    authorize Subscription

    @question.subscriptions.create(user: current_user)
  end

  def destroy
    authorize @subscription

    @question = @subscription.question
    @subscription.destroy!

  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:question_id])
  end

  def find_subscription
    @subscription = Subscription.find(params[:id])
  end
end
