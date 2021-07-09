# Preview all emails at http://localhost:3000/rails/mailers/daily_digest
class DailyDigestPreview < ActionMailer::Preview

  def digest(user = User.first)
    # @questions = Question.where('created_at > ?', Date.yesterday).map(&:title).join(', ')
    @questions = Question.last(3).pluck(:title).join(', ')
    @greeting = "Hello, #{user.email}"

    mail to: user.email, subject: "Yesterday questions from QNA"
  end
end
