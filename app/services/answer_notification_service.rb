class AnswerNotificationService

  def send_notice(answer)
    answer.question.subscriptions.find_each(batch_size: 500) do |subscription|
      AnswerNotificationMailer.notice(subscription.user, answer).deliver_later
    end
  end
end
