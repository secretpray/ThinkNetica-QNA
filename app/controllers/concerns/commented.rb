module Commented
  extend ActiveSupport::Concern
  include Klassify

  included do
    before_action :find_commentable, only: [:create_comment]
    before_action :find_comment, only: [:delete_comment]
    after_action :publish_create_comment, only: :create_comment
    after_action :publish_delete_comment, only: :delete_comment
  end

  def create_comment
    @comment = @commentable.comments.build(comment_params)
    authorize @comment
    # logger.debug "Comment attributes hash: #{@comment.attributes.inspect}"
    @comment.save
    respond_to do |format|
      format.js { render 'shared/create_comment' }
    end
  end

  def delete_comment
    authorize @comment
    @comment.try(:destroy)
    respond_to do |format|
      format.js { render 'shared/delete_comment' }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user)
  end

  def find_commentable
    @commentable = model_klass.find(params[:id])
  end

  def find_comment
    @comment = Comment.find(params[:id])
  end

  def publish_create_comment
    return unless @commentable.valid?

    question_id = @commentable[:question_id] || @commentable[:id]
    ActionCable.server.broadcast("questions/#{question_id}/comments", {
                                  comment_id: @comment.id,
                                  author_id: @comment.user_id,
                                  email: @comment.user.email,
                                  created_at: @comment.created_at,
                                  body: @comment.body,
                                  resource_name: @commentable.class.to_s.downcase,
                                  resource_id: @commentable.id,
                                  action: :create })
  end

  def publish_delete_comment
    question_id = @comment.commentable[:question_id] || @comment.commentable[:id]
    ActionCable.server.broadcast("questions/#{question_id}/comments", {
                                  id: @comment.id,
                                  author_id: @comment.user_id,
                                  action: :destroy })
  end
end
