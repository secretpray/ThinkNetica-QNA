class NewAnswerNotification

  def call(question)
    question.subscribers.find_each do |user|
      NewAnswerNotificationMailer.notify(email: user.email, question: question).deliver_later 
    end
  end
end
