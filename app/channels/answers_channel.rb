class AnswersChannel < ApplicationCable::Channel

  def subscribed
    stop_all_streams
    stream_from "questions/#{params[:question_id]}/answers"
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
