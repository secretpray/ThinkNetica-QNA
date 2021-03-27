class QuestionsChannel < ApplicationCable::Channel

  def subscribed
    # stop_all_streams
    stream_from 'questions_channel'
  end


  def unsubscribed
    ActionCable.server.broadcast "questions_channel", 
                                  user_id: current_user&.id, 
                                  status: 'offline',
                                  message: "User has left the 'Questions List channel' "
  end

  def receive(data)
  end

  def appear
    ActionCable.server.broadcast 'questions_channel', 
                                  current_user_id: current_user&.id, 
                                  status: 'online',
                                  message: "#{current_user&.email} has joined the 'Questions List channel' "
  end
end