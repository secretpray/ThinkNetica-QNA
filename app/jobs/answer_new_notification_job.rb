# bin/rails g job answer_new_notification
# sidekiq -q default -q mailers
# AnswerNewNotificationJob.perform_now(Answer.last)
class AnswerNewNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    AnswerNotificationService.new.send_notice(answer)
  end
end
