class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "questions/#{params[:question_id]}/comments"
  end

  def unsubscribed
  end

  def update_online_status
    list_user = ActionCable.server.pubsub.redis_connection_for_subscriptions.smembers "online"
    
    ActionCable.server.broadcast "activity_channel-#{params[:question_id]}", 
                                  id: current_user&.id, 
                                  status: "online", 
                                  list_online_users: list_user
  end
end