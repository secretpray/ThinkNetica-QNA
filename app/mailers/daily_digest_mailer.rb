# bin/rails g mailer daily_digest
class DailyDigestMailer < ApplicationMailer

  def digest(user)
    @questions = Question.yesterday
    @greeting = "Hello, #{user.email}, "

    mail to: user.email, subject: 'Yesterday questions from QNA'
  end
end
