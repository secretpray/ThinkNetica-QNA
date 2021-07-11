# bin/rails g mailer answer_notification
class AnswerNotificationMailer < ApplicationMailer

  def notice(user, answer)
    @answer = answer
    @question = answer.question

    mail to: user.email,
       subject: "Just answered question: #{@question.title}"
  end
end
