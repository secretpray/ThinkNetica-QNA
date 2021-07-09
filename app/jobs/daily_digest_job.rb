# bin/rails g job daily_digest
class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform(*args)
    return if Question.yesterday.blank?

    DailyDigestServices.new.send_digest
  end
end
