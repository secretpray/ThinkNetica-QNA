class ActivityChannel < ApplicationCable::Channel
  def subscribed
    # Init online status (redis)
    ActionCable.server.pubsub.redis_connection_for_subscriptions.sadd "online", current_user.id
    @list_user = ActionCable.server.pubsub.redis_connection_for_subscriptions.smembers "online"

    stream_from "activity_channel-#{params[:question_id]}"
    
    ActionCable.server.broadcast "activity_channel-#{params[:question_id]}", 
                                id: current_user.id, 
                                status: "online", 
                                list_online_users: @list_user
  end

  def unsubscribed
    # Remove online status (redis)
    ActionCable.server.pubsub.redis_connection_for_subscriptions.srem "online", current_user.id
    @list_user = ActionCable.server.pubsub.redis_connection_for_subscriptions.smembers "online"

    ActionCable.server.broadcast "activity_channel-#{params[:question_id]}", 
                                  user_id: current_user&.id,
                                  status: 'offline',
                                  list_online_users: @list_user
  end

  def appear
    # Get online status (redis)
    @list_user = ActionCable.server.pubsub.redis_connection_for_subscriptions.smembers "online"
    
    ActionCable.server.broadcast "activity_channel-#{params[:question_id]}", 
                                  id: current_user&.id, 
                                  status: "online", 
                                  list_online_users: @list_user
  end
end
