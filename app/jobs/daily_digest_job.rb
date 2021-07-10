# bin/rails g job daily_digest
# sidekiq -q default -q mailers
# DailyDigestServices.new.send_digest
class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # return if Question.yesterday.blank?
    DailyDigestService.new.send_digest
  end
end
