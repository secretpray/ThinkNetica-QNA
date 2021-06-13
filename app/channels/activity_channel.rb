class ActivityChannel < ApplicationCable::Channel
  periodically every: 30.seconds do
    # add User fields online (date format), touch after signing, clear after logout
    get_status_user
  end

  def subscribed
    # Init online status (redis)
    # unless Rails.env == 'test'
    ActionCable.server.pubsub.redis_connection_for_subscriptions.sadd "online", current_user.id
      # ActionCable.server.pubsub.redis_connection_for_subscriptions.pubsub('channels', "SomeChannel_#{type}_#{id}_*").each do |channel|
      #   ActionCable.server.broadcast(channel, data)
      # end
    @list_user = ActionCable.server.pubsub.redis_connection_for_subscriptions.smembers "online"
    # end
    stream_from "activity_channel-#{params[:question_id]}"
    # current_user = User.first if Rails.env == 'test'
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
    get_status_user
  end

  def get_status_user
    @list_user = ActionCable.server.pubsub.redis_connection_for_subscriptions.smembers "online"

    ActionCable.server.broadcast "activity_channel-#{params[:question_id]}",
                                  id: current_user&.id,
                                  status: "online",
                                  list_online_users: @list_user
  end
end
